#!/usr/bin/env bash

# Define some colors
RESET=$(tput sgr0)
export RESET
RED=$(tput setaf 1)
export RED
GREEN=$(tput setaf 2)
export GREEN
YELLOW=$(tput setaf 3)
export YELLOW
BLUE=$(tput setaf 4)
export BLUE
PURPLE=$(tput setaf 5)
export PURPLE

# Check keyboard config
checkKeyboardConfig() {
    true
    if [ -f /etc/X11/xorg.conf.d/00-keyboard.conf ] && [ -f /etc/default/keyboard ]
    then
        echo "${GREEN}Keyboard configuration looks ok"
        echo "Nothing to do.${RESET}"
    elif ! [ -f /etc/X11/xorg.conf.d/00-keyboard.conf ] && [ -f /etc/default/keyboard ];    then
        echo "${RED}Missing /etc/X11/xorg.conf.d/00-keyboard.conf file !${RESET}"
        bash "$setup_dir/scripts/keyboard.sh x11"
    elif ! [ -f /etc/default/keyboard  ] && [ -f /etc/X11/xorg.conf.d/00-keyboard.conf ]; then
        echo "${RED}Missing /etc/default/keyboard file !${RESET}"
        bash "$setup_dir/scripts/keyboard.sh default"
    else
        echo "${RED}Both files /etc/X11/xorg.conf.d/00/keyboard and /etc/default/keyboard are missing !${RESET}"
        bash "$setup_dir/scripts/keyboard.sh"
    fi
}

# Install base packages
installBase() {
    bash "$setup_dir/scripts/void-base.sh"
    read -rsn 1 -p "Press any key to continue ..."
}

installFonts() {
    bash "$setup_dir/scripts/fonts.sh"
    read -rsn 1 -p "Press any key to continue ..."
}

installGnome() {
    bash "$setup_dir/scripts/DE/gnome.sh"
    read -rsn 1 -p "Press any key to continue ..."
}

installKDE() {
    bash "$setup_dir/scripts/DE/kde.sh"
    read -rsn 1 -p "Press any key to continue ..."
}

installXFCE() {
    bash "$setup_dir/scripts/DE/xfce.sh"
    read -rsn 1 -p "Press any key to continue ..."
}

# Configure audio (PulseAudio or Pipewire)
installPulseAudio() {
    true
}

installPipewire() {
    true
}


# Install GPU drivers

# Configure flatpak if needed
installFlatpak() {
    bash "$setup_dir/scripts/flatpak.sh"
    read -rsn 1 -p "Press any key to continue ..."
}

# Enable gaming stuff

# Include some themes?

# Desktop Environment menu
deMenu() {
    
    PS3="Select a Desktop Environment: "
    local items=("gnome" "kde plasma" "xfce")

    while true; do
        clear
        # Check if there is a X11 DE/WM available
	    for dfile in /usr/share/xsessions/*.desktop 
        do
            if [ -e  "$dfile" ]; then
	            echo "${RED}A X11 desktop environment / window manager is already installed !"
	            echo "Quitting this menu${RESET}"
	            read -rsn 1 -p "Press any key to continue ..."
	            return 0
	        fi
        done

        # Check if there is a Wayland DE/WM installed
        for dfile in /usr/share/wayland-sessions/*.desktop 
        do
            if [ -e  "$dfile" ]; then
	            echo "${RED}A Wayland desktop environment or window manager is already installed !"
	            echo "Quitting this menu${RESET}"
	            read -rsn 1 -p "Press any key to continue ..."
	            return 0
	        fi
        done

        printf "%s" "${YELLOW}"
        figlet -ckf slant "Desktop environments"
        printf "%s" "${RESET}"
        select item in "${items[@]}" Quit
        do
            case $REPLY in
                1) echo "Selected item #$REPLY which means $item"; installGnome; break;;
                2) echo "Selected item #$REPLY which means $item"; installKDE; break;;
                3) echo "Selected item #$REPLY which means $item"; installXFCE; break;;
                $((${#items[@]}+1))) break 2;;
                *) echo "Ooops - unknown choice $REPLY"; break;
            esac
        done
    done
}


# Main script starts here

# Do not run as root
if [ "$(id -u)" = "0" ] ; then
	echo "${RED}Do not run this script as root or with sudo!${RESET}"
    echo
	exit
fi

setup_dir=$(dirname "$(realpath "$0")")
echo "Script path is: $setup_dir"

# First update xbps if required
echo "${YELLOW}### Updating XBPS ...${RESET}"
sudo xbps-install -u xbps
echo "${GREEN}### XBPS updated${RESET}"
# Then update the system
echo "${YELLOW}### Updating Void linux ...${RESET}"
sudo xbps-install -Suy
echo "${GREEN}### Void linux updated${RESET}"
echo
echo "${YELLOW}### Checking if figlet is installed ...${RESET}"
if command -v figlet &> /dev/null; then
    echo "${GREEN}### figlet is already installed -> nothing to do.${RESET}"
else
    echo "${YELLOW}### figlet is not installed, installing it ...${RESET}"
    sudo xbps-install -Sy figlet && echo "${GREEN}Package figlet successfully installed.${RESET}"
fi 

read -rsn 1 -p "Press any key to continue ..."

clear

# Checking keyboard config
checkKeyboardConfig
read -rsn 1 -p "Press any key to continue ..."

# Main menu
PS3="Select an option: "
declare items=("Base packages" "Nerd fonts" "Desktop environments" "Flatpak")

while true; do
    clear
    printf "%s" "${GREEN}"
    figlet -ckf slant "EZVoid setup"
    printf "%s" "${RESET}"
    select item in "${items[@]}" Quit
    do
        case $REPLY in
            1) echo "Selected item #$REPLY which means $item"; installBase; break;;
            2) echo "Selected item #$REPLY which means $item"; installFonts; break;;
            3) echo "Selected item #$REPLY which means $item"; deMenu; break;;
            4) echo "Selected item #$REPLY which means $item"; installFlatpak; break;;
            $((${#items[@]}+1))) echo "${GREEN}We're done!${RESET}"; break 2;;
            *) echo "Ooops - unknown choice $REPLY"; break;
        esac
    done
done

