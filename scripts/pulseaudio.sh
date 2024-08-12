#!/usr/bin/env bash
# TODO: check if PipeWire is already installed / active to avoid conflicts
sudo xbps-install -Sy pulseaudio pulseaudio-utils pulsemixer alsa-plugins-pulseaudio
# Volume icon to be able to display in systray
sudo xbps-install -Sy volumeicon
