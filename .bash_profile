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
# completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion;
fi
# alias
if [ -f $HOME/.shell/alias.sh ]; then
  . $HOME/.shell/alias.sh;
fi
# environments
if [ -f $HOME/.shell/environments.sh ]; then
  . $HOME/.shell/environments.sh;
fi
