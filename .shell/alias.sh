#!/usr/bin/env bash

# greps
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# utils
alias sudo="sudo "
alias ll="ls -lthF"
alias la="ls -lthFA"
alias md="mkdir "
alias rm="rm -i"

# common
alias dte="date \"+%Y-%m-%d %H:%M:%S\""
alias pth="echo $PATH | tr : \\\\n"
alias lstcp="lsof -i -n -P | grep TCP"

# linux only
if [[ $(uname) == Linux ]]; then
  alias vim="gvim -v"
  alias xcp="xclip -selection clipboard"
  alias xcv="xclip -o"
  alias rmrtlan="sudo route del default enp0s31f6"
  alias scrnoff="xset dpms force off "
fi

# mac only
if [[ $(uname) == Darwin ]]; then
  alias perf="top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}'"
  alias fixbrew="sudo chown -R \"$USER\":admin /usr/local"
  alias fip="ipconfig getifaddr en0"
fi


