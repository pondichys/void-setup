# Arch-like installation of Void Linux with full disk encryption and btrfs
This procedure describes how to install Void Linux using an archlinux like experience booting from the XFCE live iso.

## Get the ISO image
Download the Void Linux base image for glibc (musl can be quite annoying with some software)

Boot on the iso

Once in XFCE, change the display resolution and the keyboard layout if not using US one.
Start a terminal

```bash
# Switch to root user
sudo -i
# Use bash shell instead of sh
bash
```

## Create partitions

```bash
# Install gptfdisk (easier than fdisk for scripting)
xbps-install -S gptfdisk

# List the existing devices
# Allows you to select the correct device to setup the partitions
lsblk

# In this example we'll use /dev/sda
export DISK_DEVICE="/dev/sda"
# Create a first partition for EFI
sgdisk -n1::+1G -t1:EF00 -c1:'ESP' ${DISK_DEVICE}
# Create a second partition for Void install
# As we use BTRFS subvolumes, no need to create multiple separate partitions
sgdisk -n2:: -t2:8300 -c2:'LINUX' ${DISK_DEVICE}
# Check the results
sgdisk -p ${DISK_DEVICE}
```

## Create the file systems

```bash
# Get device names from lsblk output
lsblk
# Store device names into variable
export EFI_PART='/dev/sda1'
export LINUX_PART='/dev/sda2'

# Create EFI file system
mkfs.fat -F 32 -n EFI "${EFI_PART}"

# Create the BTRFS file system
mkfs.btrfs -L VOID "${LINUX_PART}"
```

# Create directories and subvolumes

```bash
# Set BTRFS mount options
export BTRFS_OPTS="noatime,compress=zstd,discard=async"

# Mount BTRFS root on /mnt
mount -o ${BTRFS_OPTS} ${LINUX_PART} /mnt

# Create BTRFS subvolumes for Timeshift compatibility
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@root
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@log
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@srv

# Unmount the full device
umount /mnt

# Mount /mnt using @ BTRFS subvolume
mount -o ${BTRFS_OPTS},subvol=@ ${LINUX_PART} /mnt

# Create the directories for boot/efi
mkdir -p /mnt/boot/efi
mkdir /mnt/{home,opt,root,srv,tmp,var}
mkdir /mnt/var/{cache,log}

# Mount other subvolumes
mount -o ${BTRFS_OPTS},subvol=@home ${LINUX_PART} /mnt/home
mount -o ${BTRFS_OPTS},subvol=@opt ${LINUX_PART} /mnt/opt
mount -o ${BTRFS_OPTS},subvol=@root ${LINUX_PART} /mnt/root
mount -o ${BTRFS_OPTS},subvol=@srv ${LINUX_PART} /mnt/srv
mount -o ${BTRFS_OPTS},subvol=@tmp ${LINUX_PART} /mnt/tmp
mount -o ${BTRFS_OPTS},subvol=@cache ${LINUX_PART} /mnt/var/cache
mount -o ${BTRFS_OPTS},subvol=@log ${LINUX_PART} /mnt/var/log

# Mount /boot/efi
mount -o noatime ${EFI_PART} /mnt/boot/efi

# Check that everything looks ok
df -h
```

# Install the system

```bash
# Select a mirror nearby your location
# Mirror list available at https://xmirror.voidlinux.org
export REPO=https://repo-de.voidlinux.org/current
export ARCH=x86_64

# Copy the keys from the Live image
mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

# Install a base system into /mnt
XBPS_ARCH=$ARCH xbps-install -S -R "$REPO" -r /mnt base-system linux-mainline btrfs-progs micro

# Enter chroot
xchroot /mnt

# Setup permissions on root file system
chown root:root /
chmod 755 /

# Setup root password
passwd root

# Setup host name
echo voidvm > /etc/hostname

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
useradd seb
passwd seb
usermod -aG wheel seb

# Edit sudoer files to allow members of wheel group to use sudo
EDITOR=micro visudo

# Synchronize and add repos
xbps-install -S
xbps-install void-repo-nonfree void-repo-multilib
xbps-install -S
```

##Create /etc/fstab

```bash
# Get the UUIDs of the devices and store them in variables
EFI_UUID=$(blkid -s UUID -o value $EFI_PART)
ROOT_UUID=$(blkid -s UUID -o value $LINUX_PART)

cat <<EOF > /etc/fstab
UUID=$ROOT_UUID / btrfs $BTRFS_OPTS,subvol=@ 0 1
UUID=$ROOT_UUID /home btrfs $BTRFS_OPTS,subvol=@home 0 2
UUID=$EFI_UUID /boot/efi vfat defaults,noatime 0 2
tmpfs /tmp tmpfs defaults,nosuid,nodev 0 0
EOF
```

Install and setup bootloader

```bash
xbps-install grub-x86_64-efi

# Install grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Void"
```

## Finish the installation

```bash
# Install NetworkManager
xbps-install dbus elogind NetworkManager


# Reconfigure all packages - it regenerates initramfs with crypt setup
xbps-reconfigure -fa

# Exit CHROOT
exit

# Reboot
reboot
```

After the reboot

```bash
# Don't forget to enable services for dbus and NetworkManager after reboot
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/NetworkManager /var/service

# If you are using wireless or want to configure your network connection
# Use NetworkManager's TUI interface
nmtui
```
