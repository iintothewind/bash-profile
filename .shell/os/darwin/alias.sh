#!/usr/bin/env bash
# os/darwin/alias.sh: aliases that exist on macOS only.
# Loaded by init.sh in interactive shells when $OSTYPE is darwin*, after alias.sh: an alias defined
# here replaces the common alias of the same name. Same contract as alias.sh.
# No OS check in here: being in this directory is the check.

alias rrc="source $HOME/.bash_profile"
alias perf="top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}'"
alias rmdstore='find . -name ".DS_Store" -depth -exec rm {} \;'
alias fip='ipconfig getifaddr en0'
alias bru='brew update && brew upgrade && brew cleanup'

if _has gls; then
  alias ls='gls --show-control-chars --color=auto'
fi

if _has trash; then
  alias rm='trash -v '
fi
