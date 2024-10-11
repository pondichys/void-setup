#!/usr/bin/env bash

sudo xbps-install -y dbus elogin 
sudo xbps-install -y wayland qt5-wayland qt6-wayland xwayland-xorg-server
sudo xbps-install -y wayfire wf-config wf-shell wayfire-plugins-extra

# Install desktop manager
sudo xbps-install -y sddm

# Install polkit and a polkit agent
sudo xbps-install -y polkit polkit-gnome


