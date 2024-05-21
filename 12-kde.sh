sudo xbps-install -Sy wayland wayland-protocols wayland-utils xorg
sudo xbps-install -Sy avahi dbus elogind
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/avahi-daemon /var/service
sudo xbps-install -Sy kde5 kde5-baseapps

# KDE plasma extras
sudo xbps-install -Sy dolphin-plugins ffmpeg ffmpegthumbs kdeconnect kdegraphics-thumbnailers kgpg plasma-wayland-protocols Appstream

# Some apps
sudo xbps-install -Sy firefox nano neofetch

# Printer support
sudo xbps-install -Sy cups cups-filters gutenprint
sudo xbps-install -Sy print-manager #KDE plasma printing management
sudo ln -s /etc/sv/cupsd /var/service

# Scanner support

