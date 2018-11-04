#!/usr/bin/env sh

#polybar is provisioned by nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then source $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

CONFIG=$HOME/dotfiles/linux/polybar.config

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar --config=$CONFIG top
##polybar --config=$CONFIG bottom ;

echo "Bars launched..."
