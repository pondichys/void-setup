# Some laptop specific tools

# Install and enable tlp for battery optimization
sudo xbps-install -Sy tlp tlp-rdw tlpui
sudo ln -sv /etc/sv/tlp /var/service

# Install powertop for troubleshooting power consumption
sudo xbps-install -Sy powertop
