#!/usr/bin/env bash

# Configure vm.max_map_count for gaming
declare new_value=16777216
if grep -q "^vm.max_map_count" /etc/sysctl.conf; then
    sudo sed -i 's/^vm.max_map_count.*/vm.max_map_count=$new_value/' /etc/sysctl.conf
else
    echo "vm.max_map_count=$new_value" | sudo tee -a /etc/sysctl.conf
fi

sudo sysctl -p /etc/sysctl.conf

# Install gaming packages on Void Linux
# Lutris and wine
sudo xbps-install -Sy lutris wine wine-devel winetricks wine-32bit

# Install drivers
# AMD
sudo xbps-install -Sy mesa mesa-dri mesa-dri-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit
