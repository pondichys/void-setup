# Arch-like installation of Void Linux with full disk encryption, ext4 and UKI

This procedure describes how to install Void Linux using an archlinux like experience.

Download the Void Linux base image for glibc (musl can be quite annoying with some software)

Boot on the iso

Login as root to the console

```bash
# First load keymap for your keyboard layout.
loadkeys be-latin1

# Connect to Wifi using wpa_supplicant
wpa_cli

scan

scan_results

add_network

0

set_network 0 ssid "your_ssid"

set_network 0 psk "your_password"

enable_network 0

save config 

# Optional - install terminus font package
xbps-install -S terminus-font
# Optional - use a bigger font for the console
setfont ter-120n
```

Terminus font conventions
ter-{character map}{size}{style}
style b(old) or n(ormal)
Use character map 1 for ISO8859-1 Win1252 like character set

## Create partitions

```bash
# Install gptfdisk (easier than fdisk for scripting)
xbps-install -S gptfdisk

# List the existing devices
# Allows you to select the correct device to setup the partitions
lsblk

# In this example we'll use /dev/vda
export DISK_DEVICE="/dev/sda"
# Create a first partition for EFI
sgdisk -n1::+1G -t1:EF00 -c1:'ESP' ${DISK_DEVICE}
# Create a second partition for Void install
# As we use BTRFS subvolumes, no need to create multiple separate partitions
sgdisk -n2:: -t2:8300 -c2:'LINUX' ${DISK_DEVICE}
# Check the results
sgdisk -p ${DISK_DEVICE}
```

## Encrypt the partition (no LVM)

```bash
# Get device names from lsblk output
lsblk
# Store deivce names into variable
export EFI_PART='/dev/sda1'
export LINUX_PART='/dev/sda2'

cryptsetup luksFormat ${LINUX_PART} \
--type luks2 \
# Enter the passphrase twice and confirm by typing YES

# Open the LUKS partition to create the file systems
cryptsetup luksOpen ${LINUX_PART} cryptroot
```

## Create the file systems

```bash
# Create EFI file system
mkfs.fat -F 32 -n EFI ${EFI_PART}

# Create the BTRFS file system
mkfs.ext4 -L ROOT /dev/mapper/cryptroot
```

## Create directories and mount partitions

```bash
mount /dev/mapper/cryptroot /mnt

# Mount /boot
# mount --mkdir ${EFI_PART} /mnt/boot
mount --mkdir ${EFI_PART} /mnt/efi

# Check that everything looks ok
df -h
```

## Install the system

```bash
# Select a mirror nearby your location
# Mirror list available at https://xmirror.voidlinux.org
export REPO=https://repo-de.voidlinux.org/current
export XBPS_ARCH=x86_64

# Copy the keys from the Live image
mkdir -p /mnt/var/db/xbps/keys
cp -iv /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

# Install a base system into /mnt
XBPS_ARCH=$ARCH xbps-install -S -R "$REPO" -r /mnt base-system cryptsetup dracut-uefi efibootmgr refind helix

# Generate fstab
xgenfstab /mnt > /mnt/etc/fstab

# Enter chroot
xchroot /mnt

# Setup permissions on root file system
chown root:root /
chmod 755 /

# Setup root password
passwd root

# Setup host name
HOSTNAME=<set your hostname here>
echo $HOSTNAME > /etc/hostname

# Edit /etc/rc.conf with vim (or another editor you installed with the base system)
# Adapt the KEYMAP section to load your keyboard layout.
# Save the file

# Set your timezone
# You can list the available options with ls -l /usr/share/zoneinfo
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime

# Set locales
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
xbps-reconfigure -f glibc-locales

# Optional - create additional user
useradd -m seb
passwd seb
usermod -aG wheel seb

# Edit sudoer files to allow members of wheel group to use sudo
EDITOR=VIM visudo

# Synchronize and add repos
xbps-install -S
xbps-install void-repo-nonfree void-repo-multilib
xbps-install -S
```

## Setup refind boot manager

```bash
# install refind
refind-install

# move the default refind.conf tfrom /boot to /efi
mv -v /boot/refind_linux.conf /efi/EFI/refind/
```


## Setup Universal Kernel Image

```bash
# Configure dracut for UKI generation
xbps-alternatives -s dracut-uefi

LUKS_UUID=$(blkid -s UUID -o value $LINUX_PART)

# Edit /etc/default/dracut-uefi-hook to adjust some settings
# You need to set KERNEL_CMDLINE to specify the rd.luks.uuid
# If your device is a SSD and support TRIM add also rd.luks.allow-discards
# I also adjust UEFI_BUNDLE_DIR to /efi/EFI/void instead of standard /boot/efi/EFI/void
cat <<EOF >> /etc/default/dracut-uefi-hook
# My custom settings
KERNEL_CMDLINE="rd.luks.name=$LUKS_UUID=cryptroot root=/dev/mapper/cryptroot rD.luks.allow-discards loglevel=4"
UEFI_BUNDLE_DIR="/efi/EFI/void/"
EOF


# Create /etc/crypttab
cat <<EOF >> /etc/crypttab
cryptroot UUID=$LUKS_UUID none
EOF

# Configure dracut for encryption
cat <<EOF >> /etc/dracut.conf.d/10-crypt.conf
hostonly="yes"
use_fstab="yes"
install_items+=" /etc/crypttab "
EOF

# Generate UKI
xbps-reconfigure -f linux{version of linux kernel installed}
```

## Finish the installation

```bash
# Install NetworkManager
xbps-install dbus elogind NetworkManager


# Reconfigure all packages - it regenerates initramfs with crypt setup
xbps-reconfigure -fa

# Exit CHROOT
exit
```

Restart the computer. After restart is ok, enable services for dbus and NetworkManager.

```bash
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/NetworkManager /var/service

# If you are using wireless or want to configure your network connection
# Use NetworkManager's TUI interface
nmtui
```

You have now a base Void Linux installation with EXT4 file systems, disk encryption and Universal Kernel Image.

# Option - enable secure boot

As we are not encypting the EFI partition

```bash
# Switch to root
sudo -i

# Install sbctl
xbps-install -S sbctl

# Check secure boot status
# Setup mode MUST be enabled
sbctl status

# Create your own keys
sbctl create-keys

# Enroll your keys and also the one from Microsoft (just in case)
sbctl enroll-keys -m

# Now sign the following files
sbctl sign -s /efi/EFI/refind/drivers_x64/ext4_x64.efi
sbctl sign -s /efi/EFI/refind/refind/refind_x64.efi
sbctl sign -s /efi/EFI/void/linux-6.12.34_1.efi

# Check the status
sbctl status

# Reboot and see if your system starts up .... it should be ok
``` 

The sign procedure must be run everytime a new kernel is installed or if refind is updated
