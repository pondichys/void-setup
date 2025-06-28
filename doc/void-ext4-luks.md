# Arch-like installation of Void Linux with full disk encryption and btrfs

This procedure describes how to install Void Linux using an archlinux like experience.

## Prepare the installation

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
--label VOID_LUKS \
--pbkdf pbkdf2 \
--pbkdf-force-iterations 500000
# Enter the passphrase twice and confirm by typing YES

# Open the LUKS partition to create the file systems
cryptsetup luksOpen ${LINUX_PART} cryptroot
```

## Create the file systems

```bash
# Create EFI file system
mkfs.fat -F 32 -n EFI ${EFI_PART}

# Create the EXT4 file system
mkfs.ext4 -L VOID /dev/mapper/cryptroot
```

## Create directories and mount file systems

```bash
# Mount EXT4 root on /mnt
mount /dev/mapper/cryptroot /mnt

# Mount /boot/efi
mount --mkdir ${EFI_PART} /mnt/boot/efi

# Check that everything looks ok
df -h

```

## Install the system

```bash
# Select a mirror nearby your location
# Mirror list available at https://xmirror.voidlinux.org
export REPO=https://repo-de.voidlinux.org/current
export ARCH=x86_64

# Copy the keys from the Live image
mkdir -pv /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

# Install a base system into /mnt
XBPS_ARCH=$ARCH xbps-install -S -R "$REPO" -r /mnt base-system cryptsetup grub-x86_64-efi vim

# Generate /etc/fstab
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

## Setup GRUB bootloader

```bash
# Configure /etc/default/grub for encryption support
LUKS_UUID=$(blkid -o value -s UUID ${LINUX_PART})
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub
echo "rd.luks.uuid=$LUKS_UUID" >> /etc/default/grub

# Edit /etc/default/grub and add rd.luks.uuid=$LUKS_UUID to the line 
# GRUB_CMDLINE_LINUX_DEFAULT
# If your device is a SSD and support TRIM add also rd.luks.allow-discards
# Don't forget to save

# Install grub
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Void"
grub-install $DISK_DEVICE
```

## Create key file to avoid entering the passphrase 2 times at boot

```bash
# Create the key file
dd bs=1 count=64 if=/dev/urandom of=/boot/volume.key

# Add the file as a second key to unlock the volume
cryptsetup luksAddKey $LINUX_PART /boot/volume.key

# Set correct permissions on key
chmod 000 /boot/volume.key
chmod -R g-rwx,o-rwx /boot

# Create /etc/crypttab
cat <<EOF >> /etc/crypttab
cryptroot UUID=$LUKS_UUID /boot/volume.key luks
EOF

# Configure dracut to include volume.key and /etc/crypttab to initramfs
echo 'install_items+=" /boot/volume.key /etc/crypttab "' > /etc/dracut.conf.d/10-crypt.conf
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

You have now a base Void Linux installation with EXT4 file system and full disk encryption.
