# Void Setup
# Run this script to install a base configuration

# First update the system
sudo xbps-install -Suy

# Install Void non-free repository
sudo xbps-install -Sy void-repo-nonfree

# Install xtools to have some maintenance tools like vkpurge and xcheckrestart
sudo xbps-install -Sy xtools

# Install Void Service Manager and vpm wrapper for xbps-install
sudo xbps-install -Sy vsv vpm

# Get some emoji font and nerd fonts
sudo xbps-install -Sy noto-fonts-emoji nerd-fonts

# Install & enable time sync
sudo xbps-install -Sy chrony

sudo ln -sv /etc/sv/chronyd /var/service

# Install and configure socklog-void system logging daemon
sudo xbps-install -Sy socklog-void

sudo ln -sv /etc/sv/socklog-unix /var/service/
sudo ln -sv /etc/sv/nanoklogd /var/service/

# Install shells & tools
sudo xbps-install -Sy bash bash-completion
sudo xbps-install -Sy zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting

# Install some base development packages
sudo xbps-install -Sy base-devel

# Now some cool Terminal tools
sudo xbps-install -Sy bat bottom curl fd fzf jq lsd neovim ripgrep starship stow tmux tree unzip wget zoxide

# Install NetworkManager
sudo xbps-install -Sy NetworkManager NetworkManager-openvpn network-manager-applet

# Install flatpak
# sudo xbps-install -Sy flatpak

# Configure flathub repo
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install git tools
sudo xbps-install -Sy delta git github-cli lazygit

# Install Docker
sudo xbps-install docker docker-compose lazydocker

# Install Kubernetes tools
sudo xbps-install -Sy kubernetes-kind kubernetes-helm kubectl k9s

# Install terraform and tools
sudo xbps-install -Sy tflint terraform

# Install python3
sudo xbps-install -Sy python3 python3-pip

# Install keybase
sudo xbps-install -Sy kbfs keybase keybase-desktop

# Install Go and Rust languages
sudo xbps-install -Sy go rustup
