#! /bin/sh

mkdir -p  ~/.local/share/fonts/
ln -sf ~/.nix-profile/share/fonts/ ~/.local/share/fonts/nix-fonts
fc-cache -rv
