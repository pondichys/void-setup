#!/usr/bin/env bash


isInstalled() {
    if command -v "$1" &> /dev/null; then
    echo "$1 is installed"
    fi 
}


# Install base packages
installBase() {
    # First update the system
    sudo xbps-install -Suy

    # Install Void multilib and non-free repository
    sudo xbps-install -Sy void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree

    # Install xmirror to select xbps mirror
    sudo xbps-install -Sy xmirror

    # Install xtools to have some maintenance tools like vkpurge and xcheckrestart
    sudo xbps-install -Sy xtools

    # Install Void Service Manager and vpm wrapper for xbps-install
    sudo xbps-install -Sy vsv vpm

    
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
    sudo xbps-install -Sy 7zip bat bottom chezmoi curl eza fastfetch fd fzf git jq neovim ripgrep starship tmux unzip wget yazi zoxide

    # Install NetworkManager
    sudo xbps-install -Sy NetworkManager NetworkManager-openvpn network-manager-applet

    # Install git tools
    sudo xbps-install -Sy delta github-cli lazygit

    # Install zram swap service
    sudo xbps-install -Sy zramen
    #TODO: configure the compression zstd and enable the runit service
    if ! grep -iq "zstd" /etc/sv/zramen/conf
    then
        echo "export ZRAM_COMP_ALGORITHM=zstd" | sudo tee -a /etc/sv/zramen/conf
    fi
    sudo ln -s /etc/sv/zramen /var/service/

    # Create some user specific directories
    declare userlocaldirs=("$HOME/.local/bin" "$HOME/.local/share/icons" "$HOME/.local/share/fonts" "$HOME/.local/share/themes")
    for dir in "${userlocaldirs[@]}"; do
        if ! [ -d "${dir}" ]; then
            echo "${dir} does not exist -> creating it ..."
            mkdir "${dir}" && echo "${dir} created."
        else
            echo "${dir} already exists -> nothing to do."
        fi
    done
}

installFonts() {
    # Get some emoji font and nerd fonts
    # TODO nerd-fonts is a huge package -> ask for configrmation
    sudo xbps-install -Sy noto-fonts-emoji nerd-fonts
}

# Choose a DE / WM

# Configure audio (PulseAudio or Pipewire)

# Install GPU modules

# Configure flatpak if needed

# Enable gaming stuff

# Include some themes?

