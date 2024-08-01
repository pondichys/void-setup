#!/usr/bin/env bash
# Do not run as root
if [ $(id -u) = "0" ] ; then
	echo "Do not run this script as root or with sudo!"
	exit
fi

# Check that dbus service is running
sudo sv status dbus | grep ^run 2> /dev/null
if [ $? -eq 0 ]
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
