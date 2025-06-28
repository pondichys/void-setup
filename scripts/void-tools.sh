#!/usr/bin/env bash

# Void Setup
# Run this script to install some tools
figlet -ckf slant "Void tools"

sudo xbps-install -y 7zip bat bottom chezmoi curl eza fastfetch fd fzf jq ripgrep starship tmux unzip wget yazi zoxide

sudo xbps-install -y delta github-cli lazygit

