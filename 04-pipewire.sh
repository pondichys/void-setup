#!/usr/bin/env bash
echo "#################################################"
echo "#  Install Pipewire package"
echo "#################################################"
sudo xbps-install -Sy pipewire

echo "#################################################"
echo "#  Setup Pipewire package"
echo "#################################################"
pw_conf_dir="/etc/pipewire/pipewire.conf.d"
if [ ! -d "${pw_conf_dir}" ]
then
	sudo mkdir -p "${pw_conf_dir}"
fi

if [ -z "$(ls -A ${pw_conf_dir})" ]
then
	echo "Linking pipewire configuration files"
	sudo ln -sf /usr/share/examples/wireplumber/10-wireplumber.conf "${pw_conf_dir}/"
	sudo ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf "${pw_conf_dir}/"
	if [ -d /etc/xdg/autostart ]
	then
		echo "Enabling autostart of pipewire and pipewire-pulse through xdg"
		sudo ln -sf /usr/share/applications/pipewire.desktop /etc/xdg/autostart/
		sudo ln -sf /usr/share/applications/pipewire-pulse.desktop /etc/xdg/autostart/
	else
		echo "No /etc/xdg/autostart directory detected."
	fi
else
	echo "Pipewire configuration already exists -> nothing to do!"
fi
