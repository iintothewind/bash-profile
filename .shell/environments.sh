#!/usr/bin/env bash

#export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ "
export GIT_PS1_SHOWDIRTYSTATE=1
export HISTTIMEFORMAT="%y-%m-%d %T "
#export LC_CTYPE=zh_CN.UTF-8
#export LC_ALL=zh_CN.UTF-8

if type rclone > /dev/null 2>&1; then
  export RCLONE_PROGRESS=1
  export RCLONE_MAX_DEPTH=1
  export RCLONE_HUMAN_READABLE=1
fi

_SBT_OPTS="-Dsbt.repository.secure=false -Xmx2G -XX:+CMSClassUnloadingEnabled -XX:MaxMetaspaceSize=768M"

# ./local/bin
[[ -d $HOME/.local/bin ]] && export PATH="$PATH:$HOME/.local/bin"

# bun
[[ -d $HOME/.bun/bin ]] && export PATH="$PATH:$HOME/.bun/bin"

# cargo
[[ -d $HOME/.cargo/bin ]] && export PATH="$PATH:$HOME/.cargo/bin"

# Go Environments
if type go > /dev/null 2>&1; then
  export GOPATH="$HOME/.go"
  export PATH="$PATH:$GOPATH/bin"
fi

# JavaScript Environments
if type npm > /dev/null 2>&1 && [[ -d $HOME/.npm/modules ]]; then
  export PATH="$PATH:$HOME/.npm/modules/bin"
fi

# linux only
if [[ $(uname) == Linux ]]; then
  # haskell-platform
  [[ -d $HOME/.cabal ]] && export PATH="$PATH:$HOME/.cabal/bin"

  # Java Environments
  if [[ -f /usr/bin/java ]]; then
    #export JAVA_HOME="/usr/java/jdk1.8.0_181"
    export SBT_OPTS="$_SBT_OPTS"
  fi

  # Rust Environments
  if type rustc > /dev/null 2>&1; then
    export PATH="$PATH:$HOME/.cargo/bin"
  fi

  for _py in python python3; do
    pyversion=$($_py --version 2>&1)
    if [[ "$pyversion" == *Python*?.?.?* && -f /usr/local/bin/virtualenvwrapper.sh && -f /usr/bin/$_py ]]; then
      export VIRTUALENVWRAPPER_PYTHON="/usr/bin/$_py"
      export WORKON_HOME="$HOME/.envs"
    fi
  done
fi

# mac only
if [[ $(uname) == Darwin ]]; then
  # gnubin
  [[ -d $BREW_PREFIX/coreutils/libexec/gnubin ]] && \
    export PATH="$BREW_PREFIX/coreutils/libexec/gnubin:$PATH"

  # brew sbin
  [[ -d /usr/local/sbin ]] && export PATH="$PATH:/usr/local/sbin"

  # Sqlite Environments
  #if [[ -d $BREW_PREFIX/sqlite ]]; then
  #export PATH="$PATH:$BREW_PREFIX/sqlite/bin"
  #fi

  # haskell-platform
  [[ -d $HOME/Library/Haskell ]] && export PATH="$PATH:$HOME/Library/Haskell/bin"

  # H2 drivers
  if [[ -d $BREW_PREFIX/h2 ]]; then
    _mssql_jdbc="$HOME/.m2/repository/com/microsoft/sqlserver/mssql-jdbc/6.2.1.jre8/mssql-jdbc-6.2.1.jre8.jar"
    [[ -f $_mssql_jdbc ]] && export H2DRIVERS="$_mssql_jdbc"
  fi

  # Python Environments
  for _py in python python3; do
    pyversion=$($_py --version 2>&1)
    if [[ "$pyversion" == *Python*?.?.?* ]]; then
      [[ -d "$HOME/Library/Python/${pyversion:7:3}/bin" ]] && \
        export PATH="$PATH:$HOME/Library/Python/${pyversion:7:3}/bin"
      if [[ -f /usr/local/bin/virtualenvwrapper.sh && -f $BREW_BIN/$_py ]]; then
        export VIRTUALENVWRAPPER_PYTHON="$BREW_BIN/$_py"
        export WORKON_HOME="$HOME/.envs"
      fi
    fi
  done

  # Java Environments
  javaHome=$(/usr/libexec/java_home -v 1.8 2>&1)
  if [[ "$javaHome" == *jdk1.8* ]] || [[ "$javaHome" == *jdk-8* ]]; then
    export JAVA_HOME=$javaHome
    export SBT_OPTS="$_SBT_OPTS"
  fi

  if [[ -s "$BREW_PREFIX/nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
  fi

  # gnuman
  [[ -d $BREW_PREFIX/coreutils/libexec/gnuman ]] && \
    export MANPATH="$BREW_PREFIX/coreutils/libexec/gnuman:$MANPATH"

  # brew settings
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

unset _SBT_OPTS _mssql_jdbc _py pyversion javaHome
