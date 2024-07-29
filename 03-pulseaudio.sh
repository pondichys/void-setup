#!/usr/bin/env bash
sudo xbps-install -Sy pulseaudio pulseaudio-utils pulsemixer alsa-plugins-pulseaudio

# Volume icon to be able to display in systray
sudo xbps-install -Sy volumeicon
