# Install DK Window Manager and utilities

echo "Installing Xorg, dbus, elogind"
sudo xbps-install -Sy xorg dbus elogind polkit

echo "Install DK window manager"
sudo xbps-install -Sy dk

echo "Install some utilities"
sudo xbps-install -Sy alacritty dunst feh lxappearance numlockx picom rofi sxhkd xfce-polkit

# Install xdg utils
sudo xbps-install -Sy xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils

# Usefull components when using tiling window manager
# Thunar file manager
sudo xbps-install -Sy Thunar thunar-volman thunar-archive-plugin gvfs gvfs-afc gvfs-mtp gvfs-smb

# Polybar
sudo xbps-install -Sy polybar
# There is also yambar
# sudo xbps-sintall -Sy yambar

# Power settings
sudo xbps-install -Sy xfce4-power-manager

# Lock screen
sudo xbps-install -Sy betterlockscreen
