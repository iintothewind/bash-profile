# ls color
if brew list | grep coreutils > /dev/null ; then
  PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  alias ls='ls -F --show-control-chars --color=auto'
  eval `gdircolors -b $HOME/.dir_colors`
fi
# prompt
if [ -f $HOME/.shell/prompt.sh ]; then
  . $HOME/.shell/prompt.sh;
fi
# proxy
if [ -f $HOME/.shell/proxy.sh ]; then
  . $HOME/.shell/proxy.sh;
fi
# alias
if [ -f $HOME/.shell/alias.sh ]; then
  . $HOME/.shell/alias.sh;
fi
# completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion;
fi
# exports
#export PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$ "
export GIT_PS1_SHOWDIRTYSTATE=1
export HISTTIMEFORMAT="%y-%m-%d %T "
export LC_CTYPE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

