# Void Setup
# Run this script to install a base configuration

# First update the system
sudo xbps-install -Suy

# Install Void multilib and non-free repository
sudo xbps-install -Sy void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree

# Install xtools to have some maintenance tools like vkpurge and xcheckrestart
sudo xbps-install -Sy xtools

# Install Void Service Manager and vpm wrapper for xbps-install
sudo xbps-install -Sy vsv vpm

# Get some emoji font and nerd fonts
sudo xbps-install -Sy noto-fonts-emoji nerd-fonts

# Install and configure socklog-void system logging daemon
sudo xbps-install -Sy socklog-void

sudo ln -sv /etc/sv/socklog-unix /var/service/
sudo ln -sv /etc/sv/nanoklogd /var/service/

# Install shells & tools
sudo xbps-install -Sy bash bash-completion
sudo xbps-install -Sy zsh zsh-completions
sudo xbps-install -Sy fish-shell

# Install some base development packages
sudo xbps-install -Sy base-devel

# Now some cool Terminal tools
sudo xbps-install -Sy 7zip bat bottom chezmoi curl eza fastfetch fd fzf jq neovim ripgrep starship tmux unzip wget yazi zoxide

# Install NetworkManager
sudo xbps-install -Sy NetworkManager NetworkManager-openvpn network-manager-applet

# Install flatpak
sudo xbps-install -Sy flatpak

# Configure flathub repo
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install git tools
sudo xbps-install -Sy delta git github-cli lazygit

# Install zram swap service
sudo xbps-install -Sy zramen
#TODO: configure the compression zstd and enable the runit service
if ! grep -iq "zstd" /etc/sv/zramen/conf
then
	echo "export ZRAM_COMP_ALGORITHM=zstd" | sudo tee -a /etc/sv/zramen/conf
fi
sudo ln -s /etc/sv/zramen /var/service/
