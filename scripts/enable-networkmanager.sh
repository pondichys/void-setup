#!/usr/bin/env bash
if ! (sudo sv status NetworkManager | grep ^run 2> /dev/null)
then
	echo "NetworkManager service is already running -> nothing to do!"
else
	echo # Install NetworkManager
	sudo xbps-install -Sy NetworkManager

	echo ###### NetworkManager requires dbus service - ensure it is running before continuing
	if ! (sudo sv status dbus | grep ^run 2> /dev/null)
	then
		echo ####### Disabling current network services
		sudo rm /var/service/dhcpcd 2> /dev/null
		sudo rm /var/service/wpa_supplicant 2> /dev/null

		echo ####### Enabling NetworkManager
		sudo ln -sf /etc/sv/NetworkManager /var/service
	else
		echo "dbus service is not running. Enable it and run this script again."
	fi
fi

echo "End of Network Manager configuration."
