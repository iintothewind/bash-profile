#!/usr/bin/env bash
# os/linux/alias.sh: aliases that exist on Linux only, whatever the distribution.
# Loaded by init.sh in interactive shells when $OSTYPE is linux*, after alias.sh and before the
# distribution layers: an alias defined here replaces the common alias of the same name.
# Same contract as alias.sh. No OS check in here: being in this directory is the check.

alias rrc="source $HOME/.bashrc"
alias ls='ls --show-control-chars --color=auto'
alias scrnoff='xset dpms force off '

if _has gvim; then
  alias vim='gvim -v'
fi

if _has xclip; then
  alias xcp='xclip -selection clipboard'
  alias xcv='xclip -o'
fi

if _has systemctl; then
  alias lsvc='systemctl list-units --type=service'
fi

# CPU temperature in degrees Celsius (Raspberry Pi and other boards exposing a thermal zone)
if [[ -r /sys/class/thermal/thermal_zone0/temp ]]; then
  alias cputemp='bcal "$(cat /sys/class/thermal/thermal_zone0/temp)/1000"'
fi
