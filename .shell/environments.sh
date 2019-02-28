#!/usr/bin/env bash

#export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ "
export GIT_PS1_SHOWDIRTYSTATE=1
export HISTTIMEFORMAT="%y-%m-%d %T "
export LC_CTYPE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# linux only
if [[ $(uname) == Linux ]]; then
  # ./local/bin
  if test -d $HOME/.local/bin; then
    export PATH="$PATH:$HOME/.local/bin"
  fi
  # haskell-platform
  if test -d $HOME/.cabal; then
    export PATH="$PATH:$HOME/.cabal/bin"
  fi
  # Java Environments
  if test -f /usr/bin/java; then
    #export JAVA_HOME="/usr/java/jdk1.8.0_181"
    export SBT_OPTS="-Dsbt.repository.secure=false -Xmx2G -XX:+CMSClassUnloadingEnabled -XX:MaxMetaspaceSize=768M"
  fi

  # Go Environments
  if type go > /dev/null 2>&1 ; then
    export GOPATH="$HOME/.go"
    export PATH="$PATH:$GOPATH/bin"
  fi

  # Python Environments
  if test -f $HOME/.local/bin/virtualenvwrapper.sh; then
    #export VIRTUALENVWRAPPER_PYTHON="$BREW_PREFIX/python/bin/python"
    export WORKON_HOME="$HOME/.envs"
  fi
fi

# mac only
if [[ $(uname) == Darwin ]]; then
  # gnubin
  if test -d $BREW_PREFIX/coreutils/libexec/gnubin; then
    export PATH="$BREW_PREFIX/coreutils/libexec/gnubin:$PATH"
  fi

  # ./local/bin
  if test -d $HOME/.local/bin; then
    export PATH="$PATH:$HOME/.local/bin"
  fi

  # brew sbin
  if test -d /usr/local/sbin; then
    export PATH="$PATH:/usr/local/sbin"
  fi

  # Sqlite Environments
  #if test -d $BREW_PREFIX/sqlite; then
  #export PATH="$PATH:$BREW_PREFIX/sqlite/bin"
  #fi

  # haskell-platform
  if test -d $HOME/Library/Haskell; then
    export PATH="$PATH:$HOME/Library/Haskell/bin"
  fi


  # H2 drivers
  if test -d $BREW_PREFIX/h2; then
    if test -f $HOME/.m2/repository/com/microsoft/sqlserver/mssql-jdbc/6.2.1.jre8/mssql-jdbc-6.2.1.jre8.jar; then
      export H2DRIVERS="$HOME/.m2/repository/com/microsoft/sqlserver/mssql-jdbc/6.2.1.jre8/mssql-jdbc-6.2.1.jre8.jar"
    fi
  fi

  # Python Environments
  if test -d $HOME/Library/Python/2.7/bin; then
    export PATH="$PATH:$HOME/Library/Python/2.7/bin"
  fi

  pyversion=$(python --version 2>&1)
  if [[ "$pyversion" == *2.7* ]]; then
    if test -f /usr/local/bin/virtualenvwrapper.sh && test -f $BREW_BIN/python; then
      export VIRTUALENVWRAPPER_PYTHON="$BREW_BIN/python"
      export WORKON_HOME="$HOME/.envs"
    fi
  else
    if test -f /usr/local/bin/virtualenvwrapper.sh && test -f $BREW_BIN/python3; then
      export VIRTUALENVWRAPPER_PYTHON="$BREW_BIN/python3"
      export WORKON_HOME="$HOME/.envs"
    fi
  fi

  # Java Environments
  if test -f /usr/bin/java; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
    export SBT_OPTS="-Dsbt.repository.secure=false -Xmx2G -XX:+CMSClassUnloadingEnabled -XX:MaxMetaspaceSize=768M"
  fi

  # Go Environments
  if type go > /dev/null 2>&1 ; then
    export GOPATH="$HOME/.go"
    export PATH="$PATH:$GOPATH/bin"
  fi

  # JavaScript Environments
  if type npm > /dev/null 2>&1 && test -d ~/.npm/modoules; then
    export PATH="$PATH:~/.npm/modoules/bin"
  fi


  # gnuman
  if test -d $BREW_PREFIX/coreutils/libexec/gnuman; then
    export MANPTH="$BREW_PREFIX/coreutils/libexec/gnuman:$MANPATH"
  fi

  # brew settings
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  #export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.shu.edu.cn/homebrew-bottles"
fi
