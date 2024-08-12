#!/usr/bin/env bash
#
# Wayfire installation script
#
sudo xbps-install -Sy wayland wayland-protocols wayland-utils 
sudo xbps-install -Sy xorg xorg-server-xwayland

sudo xbps-install -Sy wayfire wf-shell wlogout
sudo xbps-install alacritty grim slurp swayidle swaylock mako wlsunset wofi

