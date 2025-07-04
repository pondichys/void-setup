#!/usr/bin/env bash

figlet -ckf slant "Flatpak"

# Check that dbus service is running
if ! (sudo sv status dbus | grep ^run 2> /dev/null)
then
	echo "DBUS service not running!"
	echo "Please install and/or start dus service before installing flatpaks."
	exit
else
# Install flatpak
	sudo xbps-install -Sy flatpak
# Configure flathub repo
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
