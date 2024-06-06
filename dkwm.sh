#!/usr/bin/env bash

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
sudo xbps-install -Sy yambar

# Power settings
sudo xbps-install -Sy xfce4-power-manager

# Lock screen
sudo xbps-install -Sy betterlockscreen

if [ ! -d "$HOME/.config/dk" ]
then
	echo "Setup basic configuration files"
	mkdir -p "$HOME/.config/dk"
	cp /usr/share/doc/dk/{dkrc,sxhkdrc} "$HOME/.config/dk/"
else
	echo "Configuration directory $HOME/.config/dk detected. Please check your config files."
fi

echo -n "Enter your keyboard layout (default us): "
read -r kblayout

# Sets the keyboard mapping to be for X11 if it does not exist yet
if [ ! -f /etc/X11/xorg.conf.d/00-keyboard.conf ]
then
	sudo mkdir -p /etc/X11/xorg.conf.d
	sudo touch /etc/X11/xorg.conf.d/00-keyboard.conf
	cat <<EOF | sudo tee -a /etc/X11/xorg.conf.d/00-keyboard.conf 
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "${kblayout:-us}"
EndSection
EOF
fi
