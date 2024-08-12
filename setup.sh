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
    if ! grep -iq "zstd" /etc/sv/zramen/conf
    then
        echo "export ZRAM_COMP_ALGORITHM=zstd" | sudo tee -a /etc/sv/zramen/conf
    fi
    sudo ln -s /etc/sv/zramen /var/service/

    # Create some user specific directories
    local userlocaldirs=("$HOME/.local/bin" "$HOME/.local/share/icons" "$HOME/.local/share/fonts" "$HOME/.local/share/themes")
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
    # TODO nerd-fonts is a huge package -> ask for confirmation
    sudo xbps-install -Sy noto-fonts-emoji nerd-fonts
}

# Choose a DE / WM
installX11() {
    sudo xbps-install -Sy xorg
}

installWayland() {
    sudo xbps-install -Sy wayland wayland-protocols wayland-utils
}

installDECommon() {
    sudo xbps-install -Sy avahi dbus elogind xclip
    sudo ln -sf /etc/sv/avahi-daemon /var/service
    sudo ln -sf /etc/sv/dbus /var/service
}

installGnome() {
    sudo xbps-install -Sy gnome-core
}


# Configure audio (PulseAudio or Pipewire)
installPulseAudio() {
    sudo xbps-install -Sy pulseaudio pulseaudio-utils pulsemixer alsa-plugins-pulseaudio
    # Volume icon to be able to display in systray
    sudo xbps-install -Sy volumeicon
}

installPipewire() {
    echo "#################################################"
    echo "#  Install Pipewire package"
    echo "#################################################"
    sudo xbps-install -Sy pipewire

    echo "#################################################"
    echo "#  Setup Pipewire package"
    echo "#################################################"
    local pw_conf_dir="/etc/pipewire/pipewire.conf.d"
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
}


# Install GPU drivers

# Configure flatpak if needed
installFlatpak() {
    # Check that dbus service is running
    if ! sudo sv status dbus | grep ^run 2> /dev/null
    then
        echo "DBUS service not running!"
        echo "Please install and/or start dbus service before installing flatpaks."
        exit
    else
    # Install flatpak
        sudo xbps-install -Sy flatpak
    # Configure flathub repo
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
}

# Enable gaming stuff

# Include some themes?

# Main menu
PS3="Select an option: "
items=("base" "fonts" "audio" "flatpak")


