# Install everything to run Awesome window manager

# Install base packages
# Wezterm: terminal
# dbus: message bus system
# elogind: login manager
# lxappearance: settings for GTK themes
# numlockx: activate numlock at startup
# picom: compositor
# sddm: display manager
# xorg: meta package for X server
sudo xbps-install -Sy dbus elogind lxappearance numlockx picom sddm xorg

# Enable dbus as a service. elogind service is not needed as it will be handled by dbus service.
sudo ln -s /etc/sv/dbus /var/service

# Install xdg utils
sudo xbps-install -Sy xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils

# Create current user XDG directories
xdg-user-dirs-update

# Install AwesomeWM
sudo xbps-install -Sy awesome

# Wallpaper managers
sudo xbps-install -Sy feh

# Usefull components when using tiling window manager
# Thunar file manager
sudo xbps-install -Sy Thunar thunar-volman thunar-archive-plugin gvfs gvfs-afc gvfs-mtp gvfs-smb

# Power settings
sudo xbps-install -Sy xfce4-power-manager

# Create AwesomeWM configuration directory and put standard config file
if [ ! -d  "$HOME/.config/awesomewm" ]
then
	mkdir -p "$HOME"/.config/awesomewm
fi

if [ ! -f "$HOME/.config/awesome/rc.lua" ]
then
	cp /etc/xdg/awesome/rc.lua "$HOME/.config/awesome/"
fi

# Dependencies for SDDM Sugar Candy theme
sudo xbps-install -Sy qt5-graphicaleffects qt5-quickcontrols2 qt5-svg

# GTK themes
sudo xbps-install -Sy arc-theme arc-icon-theme
