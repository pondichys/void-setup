#!/usr/bin/env bash
printf "%s" "${YELLOW}"
figlet -ckf slant Gnome
printf "%s" "${RESET}"

script_dir=$(dirname "$(realpath $0)")
echo "Script path is: $script_dir"

# shellcheck disable=SC1091
source "$script_dir/de_common.sh"

installX11
installWayland
installDECommon

sudo xbps-install -Sy gnome-core gnome-terminal gnome-tweaks extension-manager
sudo xbps-install -Sy xdg-desktop-portal xdg-desktop-portal-gnome
# Support for virtual filesystems in Nautilus
sudo xbps-install -Sy gvfs-afc gvfs-mtp gvfs-smb
# GUI for package management
sudo xbps-install -Sy octoxbps

# Enable GDM message
echo "
${PURPLE}Enable GDM as your display manager by running the following command:
    sudo ln -sf /etc/sv/gdm /var/service

Be sure to first check that no other display manager is enabled.${RESET}
"
