#!/usr/bin/env bash
figlet -ckf slant "Print and Scan"

# Install CUPS services for printing
sudo xbps-install -y cups cups-filters
sudo ln -sf /etc/sv/cupsd /var/service

# Package for wifi printing
sudo xbps-install -y avahi avahi-utils nss-mdns
sudo ln -sf /etc/sv/avahi-daemon /var/service

# Install SANE for scanning
sudo xbps-install -y sane sane-airscan
