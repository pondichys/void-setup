sudo xbps-install -Sy wayland wayland-protocols wayland-utils xorg
sudo xbps-install -Sy avahi dbus elogind
sudo ln -s /etc/sv/dbus /var/service
sudo xbps-install -Sy kde5 kde5-baseapps

# KDE plasma extras
sudo xbps-install -Sy dolphin-plugins ffmpeg ffmpegthumbs kdeconnect kgpg plasma-wayland-protocols
sudo xbps-install -Sy firefox
