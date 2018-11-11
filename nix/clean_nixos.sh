#! /bin/sh

#nix-channel --update
nix-env -p /nix/var/nix/profiles/system --delete-generations old
nix-collect-garbage -d
