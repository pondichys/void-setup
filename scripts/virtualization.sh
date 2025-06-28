#!/usr/bin/env bash

# Setup virtualization tools on Void Linux
# Ref: https://www.dwarmstrong.org/virtualization-void-linux

echo "Install required packages"
sudo xbps-install -y libvirt virt-manager qemu polkit

echo "Add user $USER to kvm and libvirt groups"
sudo usermod -a -G libvirt,kvm $USER

echo "Enable required services"
sudo ln -sf /etc/sv/libvirtd /var/service
sudo ln -sf /etc/sv/virtlockd /var/service
sudo ln -sf /etc/sv/virtlogd /var/service

echo "Virtualization installed.You must logout and login to activate the changes."

