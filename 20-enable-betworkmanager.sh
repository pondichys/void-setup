echo ###### NetworkManager requires dbus service - ensure it is running before continuing !

echo ####### Disabling current network services
sudo rm /var/service/dhcpcd
sudo rm /var/service/wpa_supplicant

echo ####### Enabling NetworkManager
sudo ln -s /etc/sv/NetworkManager /var/service
