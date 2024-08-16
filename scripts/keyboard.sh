#!/usr/bin/env bash

configX11() {
    cat <<EOF | sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "${kb_layout}"
    Option "XkbVariant" "${kb_variant}"
EndSection
EOF
}

configDefaultKB() {
    cat <<EOF | sudo tee /etc/default/keyboard
XKBMODEL="pc105"
XKBLAYOUT="${kb_layout}"
XKBVARIANT="${kb_variant}"
BACKSPACE="guess"
EOF
}

kb_layout="be"
kb_variant=""

read -r -p "Select a keyboard layout (default: be): " kb_layout
read -r -p "Select a keyboard variant 'default: empty): " kb_variant

if [ "$1" = "x11" ]; then
    if ! [ -d /etc/X11/xorg.conf.d ]; then
        sudo mkdir -p /etc/X11/xorg.conf.d
    fi
    configX11
elif [ "$1" = "default" ]; then
    configDefaultKB
else
    if ! [ -d /etc/X11/xorg.conf.d ]; then
        sudo mkdir -p /etc/X11/xorg.conf.d
    fi
    configX11
    configDefaultKB
fi

echo "Keyboard configuration complete."
read -rsn 1 -p "Press any key to continue ..."
