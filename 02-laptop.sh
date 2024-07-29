#!/usr/bin/env bash
# Some laptop specific tools

# Install and enable tlp for battery optimization
sudo xbps-install -Sy tlp tlp-rdw tlpui
sudo ln -sv /etc/sv/tlp /var/service

# Install powertop for troubleshooting power consumption
sudo xbps-install -Sy powertop

# Setup touchpad for X11
if [ ! -d /etc/X11/xorg.conf.d ]; then
	sudo mkdir -p /etc/X11/xorg.conf.d
fi

if [ ! -r /etc/X11/xorg.conf.d/30-touchpad.conf ]; then
	cat <<EOF | sudo tee -a /etc/X11/xorg.conf.d/30.touchpad.conf
	Section "InputClass"
	    Identifier "touchpad"
    	Driver "libinput"
    	MatchIsTouchpad "on"
    	Option "Tapping" "on"
	EndSection
	EOF
fi
