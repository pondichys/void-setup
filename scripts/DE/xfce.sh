#!/usr/bin/env bash
# shellcheck disable=SC1091

printf "%s" "${YELLOW}"
figlet -ckf slant "XFCE 4"
printf "%s" "${RESET}"

script_dir=$(dirname "$(realpath "$0")")
echo "Script path is: $script_dir"
source "$script_dir/de_common.sh"

installX11
# installWayland
installDECommon

sudo xbps-install -Sy xfce4 xfce4-plugins thunar-archive-plugin thunar-media-tags-plugin thunar-volman file-roller mugshot
sudo xbps-install -Sy xdg-desktop-portal xdg-desktop-portal-gtk

# Support for virtual filesystems
sudo xbps-install -Sy gvfs-afc gvfs-mtp gvfs-smb

sudo xbps-install -Sy octoxbps

# Enable LightDM message
echo "
${PURPLE}Enable LightDM as your display manager by running the following command:
    sudo ln -sf /etc/sv/lightdm /var/service

Be sure to first check that no other display manager is enabled.${RESET}
"
