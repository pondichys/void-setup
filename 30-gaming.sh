# Install gaming packages on Void Linux
# Lutris and wine
sudo xbps-install -Sy lutris wine wine-devel winetricks wine-32bit

# Install drivers
# AMD
sudo xbps-install -Sy mesa mesa-dri mesa-dri-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit
