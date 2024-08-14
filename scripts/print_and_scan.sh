#!/usr/bin/env bash
figlet -ckf slant "Print and Scan"

# Install CUPS services for printing
sudo xbps-install -Sy cups cups-filters
sudo ln -s /etc/sv/cupsd /var/service

# Package for wifi printing
sudo xbps-install -Sy nss-mdns

# Install SANE for scanning
sudo xbps-install -Sy sane sane-airscan
