#!/usr/bin/env bash

#export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ "
export GIT_PS1_SHOWDIRTYSTATE=1
export HISTTIMEFORMAT="%y-%m-%d %T "
export LC_CTYPE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# Haskell Environments
export HASKELL_HOME="$HOME/Library/Haskell"

# Python Environments
export PYTHON_HOME="$HOME/Library/Python/2.7"
export WORKON_HOME="$HOME/.envs"

# Path
export PATH="$PATH:$HASKELL_HOME/bin:$PYTHON_HOME/bin"
