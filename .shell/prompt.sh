#!/usr/bin/env bash

# @gf3’s Sexy Bash Prompt, inspired by “Extravagant Zsh Prompt”
# Shamelessly copied from https://github.com/gf3/dotfiles
# Screenshot: http://i.imgur.com/s0Blh.png

#if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
#  export TERM=gnome-256color
#elif infocmp xterm-256color >/dev/null 2>&1; then
#  export TERM=xterm-256color
#fi

if tput setaf 1 &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    # Changed these colors to fit Solarized theme
    MAGENTA=$(tput setaf 125)
    ORANGE=$(tput setaf 166)
    GREEN=$(tput setaf 64)
    PURPLE=$(tput setaf 61)
    WHITE=$(tput setaf 244)
  else
    MAGENTA=$(tput setaf 5)
    ORANGE=$(tput setaf 4)
    GREEN=$(tput setaf 2)
    PURPLE=$(tput setaf 1)
    WHITE=$(tput setaf 7)
  fi
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
  else
  MAGENTA="\033[1;31m"
  ORANGE="\033[1;33m"
  GREEN="\033[1;32m"
  PURPLE="\033[1;35m"
  WHITE="\033[1;37m"
  BOLD=""
  RESET="\033[m"
fi

export MAGENT
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

#function parse_git_dirty() {
  #[[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
#}

#function parse_git_branch() {
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
#}

#if type git > /dev/null 2>&1 ; then
  #export PS1="\[${BOLD}${MAGENTA}\]\u\[$WHITE\] at \[$ORANGE\]\h\[$WHITE\] in \[$GREEN\]\W\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(if type parse_git_branch > /dev/null 2>&1; then parse_git_branch; else echo 'gitbranch'; fi)\[$WHITE\]\n\$ \[$RESET\]"
  #else
  #export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ "
#fi

export PS1="\[${BOLD}${MAGENTA}\]\u\[$WHITE\] at \[$ORANGE\]\h\[$WHITE\] in \[$GREEN\]\W\[$WHITE\]\n\$\[$RESET\] "

# use default prompt for text mode
#if [[ $(tty) == \/dev\/tty[0-6]* ]]; then
#  export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ "
#fi

