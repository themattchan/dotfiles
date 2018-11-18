#!/usr/bin/env sh

#polybar is provisioned by nix
# if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then source $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

CONFIG=$HOME/dotfiles/linux/polybar.config

# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar --config=$CONFIG -l info bottom &
polybar --config=$CONFIG -l info top &

echo "Bars launched..."
