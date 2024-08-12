#!/usr/bin/env bash
# Install packages for Intel GPUs
sudo xbps-install -Sy linux-firmware-intel \
  mesa-dri \
  vulkan-loader mesa-vulkan-intel \
  intel-media-driver
