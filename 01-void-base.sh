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

# Install & enable time sync
sudo xbps-install -S chrony

sudo ln -sv /etc/sv/chronyd /var/service

# Install and configure socklog-void system logging daemon
sudo xbps-install -S socklog-void

sudo ln -sv /etc/sv/socklog-unix /var/service/
sudo ln -sv /etc/sv/nanoklogd /var/service/

# Install shells & tools
sudo xbps-install -S bash bash-completion
sudo xbps-install -S zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
sudo xbps-install -S shellcheck

# Now some cool Terminal tools
sudo xbps-install -S bat byobu curl exa fd fzf jq neovim ripgrep starship stow tmux tree unzip wget zoxide

# Install NetworkManager
sudo xbps-install -S NetworkManager NetworkManager-openvpn network-manager-applet

# Install flatpak
# sudo xbps-install -S flatpak

# Configure flathub repo
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install git tools
sudo xbps-install -S delta git github-cli lazygit

# Install Docker
sudo xbps-install docker docker-compose lazydocker

# Install Kubernetes tools
sudo xbps-install -S kubernetes-kind kubernetes-helm kubectl k9s

# Install terraform and tools
sudo xbps-install -S tflint terraform

# Install python3
sudo xbps-install -S python3 python3-pip

# Install keybase
sudo xbps-install -S kbfs keybase keybase-desktop

# Install Go and Rust languages
# sudo xbps-install -S go rust
