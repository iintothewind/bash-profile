#!/usr/bin/env bash

# environments
if [ -f $HOME/.shell/environments.sh ]; then
  . $HOME/.shell/environments.sh;
fi
# proxy
if [ -f $HOME/.shell/proxy.sh ]; then
  . $HOME/.shell/proxy.sh;
fi
# alias
if [ -f $HOME/.shell/alias.sh ]; then
  . $HOME/.shell/alias.sh;
fi
# prompt
if [ -f $HOME/.shell/prompt.sh ]; then
  . $HOME/.shell/prompt.sh;
fi

# linux only
#if [[ $(uname) == Linux ]]; then
  
#fi

# mac only
if [[ $(uname) == Darwin ]]; then
  # completion
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion;
  fi
  # autojump
  if [ -f $(brew --prefix)/etc/profile.d/autojump.sh ]; then 
    . $(brew --prefix)/etc/profile.d/autojump.sh;
  fi
  # jump
  if type jump > /dev/null 2>&1; then
    eval "$(jump shell --bind=z)"
  fi
  # ls color
  #if brew list | grep coreutils > /dev/null ; then
    #PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    #alias ls='ls -F --show-control-chars --color=auto'
    #eval `gdircolors -b $HOME/.dir_colors`
  #fi

  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

  test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

