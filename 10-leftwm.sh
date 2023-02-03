# Install everything to run LeftWM tiling window manager

# Install base packages
# Alacritty: terminal
# dbus: message bus system
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
sudo xbps-install -S alacritty dbus-elogind elogind lxappearance numlockx picom rofi rxvt-unicode sddm sxhkd xfce-polkit xorg

# Install xdg utils
sudo xbps-install -S xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils

# Install LeftWM
sudo xbps-install -S leftwm

# Wallpaper managers
sudo xbps-install -S feh variety

# Usefull components when using tiling window manager
# Thunar file manager
sudo xbps-install -S Thunar thunar-volman thunar-archive-plugin

# Polybar
sudo xbps-install -S polybar

# Power settings
sudo xbps-install -S xfce4-power-manager

# Lock screen
sudo xbps-install -S betterlockscreen

# Create LeftWM configuration directory
mkdir -p $HOME/.config/leftwm

# Create sxhkd configuration directory for LeftWM
mkdir -p $HOME/.config/leftwm/sxhkd

#♣ Dependencies for SDDM Sugar Candy theme
sudo xbps-install -S qt5-graphicaleffects qt5-quickcontrols2
