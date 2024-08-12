#!/usr/bin/env bash

printf "%s" "${YELLOW}"
figlet -ckf slant "KDE plasma"
printf "%s" "${RESET}"

script_dir=$(dirname "$(realpath $0)")
echo "Script path is: $script_dir"

# shellcheck disable=SC1091
source "$script_dir/de_common.sh"

installX11
installWayland
installDECommon

sudo xbps-install -Sy wayland wayland-protocols wayland-utils xorg
sudo xbps-install -Sy avahi dbus elogind
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/avahi-daemon /var/service
sudo xbps-install -Sy kde5 kde5-baseapps
sudo xbps-install -Sy xdg-desktop-portal xdg-desktop-portal-kde
## KDE plasma extras
sudo xbps-install -Sy dolphin-plugins ffmpeg ffmpegthumbs kdeconnect kdegraphics-thumbnailers kgpg plasma-wayland-protocols print-manager
# Support for virtual filesystems in Dolphin
sudo xbps-install -Sy gvfs-afc gvfs-mtp gvfs-smb
# GUI for package management
sudo xbps-install -Sy octoxbps

# Enable SDDM message
echo "
${PURPLE}Enable SDDM as your display manager by running the following command:
    sudo ln -sf /etc/sv/sddm /var/service

Be sure to first check that no other display manager is enabled.${RESET}
"