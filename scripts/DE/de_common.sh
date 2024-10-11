#!/usr/bin/env bash

# Common functions for all Desktop Environments

installX11() {
    sudo xbps-install -Sy xorg xclip
}

installWayland() {
    sudo xbps-install -Sy wayland wayland-protocols wayland-utils xorg-server-xwayland
}

installDECommon() {
    sudo xbps-install -Sy avahi elogind 
    sudo ln -sf /etc/sv/avahi-daemon /var/service
}
