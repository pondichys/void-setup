#!/usr/bin/env bash

# Common functions for all Desktop Environments

installX11() {
    sudo xbps-install -Sy xorg
}

installWayland() {
    sudo xbps-install -Sy wayland wayland-protocols wayland-utils xorg-server-xwayland
}

installDECommon() {
    sudo xbps-install -Sy avahi elogind xclip
    sudo ln -sf /etc/sv/avahi-daemon /var/service
}
