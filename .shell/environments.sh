#!/usr/bin/env bash

#export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ "
export GIT_PS1_SHOWDIRTYSTATE=1
export HISTTIMEFORMAT="%y-%m-%d %T "
export LC_CTYPE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# linux only
#if [[ $(uname) == Linux ]]; then
  
#fi

# mac only
if [[ $(uname) == Darwin ]]; then
  # ./local/bin
  export LOCAL_BIN="$HOME/.local/bin"

  # gnubin
  export GNU_BIN="$(brew --prefix coreutils)/libexec/gnubin";

  # gnuman
  export GNU_MAN="$(brew --prefix coreutils)/libexec/gnuman";

  # brew sbin
  export BREW_SBIN="/usr/local/sbin"

  # Haskell Environments
  export HASKELL_HOME="$HOME/Library/Haskell"

  # Python Environments
  export PYTHON_HOME="$HOME/Library/Python/2.7"
  export WORKON_HOME="$HOME/.envs"

  # Java Environments
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_112.jdk/Contents/Home"

  # Path
  export PATH="$GNU_BIN:$PATH:$BREW_SBIN:$LOCAL_BIN:$HASKELL_HOME/bin:$PYTHON_HOME/bin"

  # Man Pages
  export MANPTH="$GNU_MAN:$MANPATH"

  # github api token 
  export HOMEBREW_GITHUB_API_TOKEN="a005a033359adb04f98cff208828ea927e88a523"
fi

