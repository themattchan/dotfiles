#! /bin/sh

#nix-channel --update
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
sudo nix-collect-garbage -d
nix-collect-garbage -d
