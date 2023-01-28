# Void Setup
# Run this script to install a base configuration

# First update the system
sudo xbps-install -Suy

# Install Void non-free repository
sudo xbps-install -S void-repo-nonfree

# Install xtools to have some maintenance tools like vkpurge and xcheckrestart
sudo xbps-install -S xtools

# Install Void Service Manager and vpm wrapper for xbps-install
sudo xbps-install -S vsv vpm

# Get some emoji font and nerd fonts
sudo xbps-install -S noto-fonts-emoji nerd-fonts

# Install time sync
sudo xbps-install -S chrony

sudo ln -s /etc/sv/chronyd /var/service

# Install and configure socklog-void system logging daemon
sudo xbps-install -S socklog-void

sudo ln -s /etc/sv/socklog-unix /var/service/
sudo ln -s /etc/sv/nanoklogd /var/service/

# Now some cool Terminal tools
sudo xbps-install -S bat curl exa fd fzf jq lazygit neovim ripgrep starship stow tmux tree unzip wget zellij zoxide

# Install flatpak
sudo xbps-install -S flatpak

# Configure flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

