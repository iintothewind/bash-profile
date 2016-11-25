#!/usr/bin/env bash

# greps
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# utils
alias ll="ls -lthF"
alias la="ls -lthFA"
alias md="mkdir "
alias rm="rm -i"
alias mydate="date \"+%Y-%m-%d %H:%M:%S\""
alias unixdate="date \"+%s\""
alias perf="top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}'"
alias fixbrew="sudo chown -R \"$USER\":admin /usr/local"
alias fip="ipconfig getifaddr en0"
