# Script to setup XFCE4 on Void Linux
sudo xbps-install -Sy xorg

sudo xbps-install -Sy avahi dbus elogind
sudo ln -s /etc/sv/avahi-daemon /var/service
sudo ln -s /etc/sv/dbus /var/service

sudo xbps-install -Sy xfce4 xfce4-plugins thunar-archive-plugin
sudo xbps-install -Sy xdg-desktop-portal xdg-desktop-portal-gtk

# Support for virtual filesystems
sudo xbps-install -Sy gvfs-afc gvfs-mtp gvfs-smb

sudo xbps-install -Sy firefox micro nano ufetch

sudo xbps-install -Sy octoxbps

sudo xbps-install -Sy cups cups-filters
sudo ln -s /etc/sv/cupsd /var/service

sudo xbps-install -Sy sane sane-airscan
