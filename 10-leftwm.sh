# Install everything to run LeftWM tiling window manager

# Install base packages
# Alacritty: terminal
# dbus: message bus system
# dunst: notification daemon
# elogind: login manager
# lxappearance: settings for GTK themes
# numlockx: activate numlock at startup
# picom: compositor
# rofi: application launcher
# rxvt-unicode: another terminal often used as default by tiling window managers
# sddm: display manager
# sxhkd: simple x hot key daemon - enables to configure key bindings independently of the tiling window manager
# xfce-polkit: graphical authentication agent for polkit
# xorg: meta package for X server
sudo xbps-install -Sy alacritty dbus-elogind dunst elogind lxappearance numlockx picom rofi rxvt-unicode sddm sxhkd xfce-polkit xorg

# Enable dbus as a service. elogind service is not needed as it will be handled by dbus service.
sudo ln -s /etc/sv/dbus /var/service

# Install xdg utils
sudo xbps-install -Sy xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils

# Create current user XDG directories
xdg-user-dirs-update

# Install LeftWM
sudo xbps-install -Sy leftwm

# Wallpaper managers
sudo xbps-install -Sy feh variety

# Usefull components when using tiling window manager
# Thunar file manager
sudo xbps-install -Sy Thunar thunar-volman thunar-archive-plugin

# Polybar
sudo xbps-install -Sy polybar

# Power settings
sudo xbps-install -Sy xfce4-power-manager

# Lock screen
sudo xbps-install -Sy betterlockscreen

# Create LeftWM configuration directory
mkdir -p $HOME/.config/leftwm

# Create sxhkd configuration directory for LeftWM
mkdir -p $HOME/.config/leftwm/sxhkd

# Dependencies for SDDM Sugar Candy theme
sudo xbps-install -Sy qt5-graphicaleffects qt5-quickcontrols2 qt5-svg

# GTK themes
sudo xbps-install -Sy arc-theme arc-icon-theme
