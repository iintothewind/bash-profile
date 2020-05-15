#!/usr/bin/env bash
BREW_BIN="/usr/local/bin"
BREW_PREFIX="/usr/local/opt"

# custom functions
if test -f $HOME/.shell/cf.sh; then
  . $HOME/.shell/cf.sh
fi

# environments
if test -f $HOME/.shell/environments.sh; then
  . $HOME/.shell/environments.sh
fi
# proxy
if test -f $HOME/.shell/proxy.sh; then
  . $HOME/.shell/proxy.sh
fi
# alias
if test -f $HOME/.shell/alias.sh; then
  . $HOME/.shell/alias.sh
fi
# prompt
if test -f $HOME/.shell/prompt.sh; then
  . $HOME/.shell/prompt.sh
fi
# path completion
if [[ "$SHELL" == "/usr/local/bin/bash" ]] && type gsed > /dev/null 2>&1 && test -f $HOME/.shell/path_completion.sh; then
  . $HOME/.shell/path_completion.sh
  _bcpp --defaults
fi

# linux only
if [[ $(uname) == Linux ]]; then
  if test -f /etc/bashrc; then
    . /etc/bashrc
  fi

  if [[ $(alias ls 2> /dev/null) != *"color"* ]]; then
    alias ls="ls --show-control-chars --color=auto"
  fi

  # jump
  if type jump > /dev/null 2>&1; then
    eval "$(jump shell --bind=z)"
  fi
fi

# mac only
if [[ $(uname) == Darwin ]]; then
  if test -f $BREW_BIN/gls; then
    alias ls="gls --show-control-chars --color=auto"
  fi

  # completion
  if test -f $BREW_PREFIX/etc/bash_completion; then
    . $BREW_PREFIX/etc/bash_completion;
  fi

  # autojump
  if test -f $BREW_PREFIX/etc/profile.d/autojump.sh; then
    . $BREW_PREFIX/etc/profile.d/autojump.sh;
  fi
  # jump
  if type jump > /dev/null 2>&1; then
    eval "$(jump shell --bind=z)"
  fi
fi
