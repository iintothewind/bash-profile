#!/usr/bin/env bash

# functions
function qf() { find . -name "$@" -print ;}
function genv() { env | fgrep "$@" ;}
function gps() { ps -ef | fgrep "$@" | fgrep -v fgrep ;}
function ghs() { history | fgrep "$@" | fgrep -v fgrep ;}
function gals() { alias | fgrep "$@" | fgrep -v fgrep ;}
function fftop() { find . -size +"$@" -exec ls -lhs {} \+ | sort -nr ;} 

function md() {
  if [ ! -n "$1" ]; then
    echo "enter a name for this folder"
  elif [ -d $1 ]; then
    echo "$1 already exists"
  else
    mkdir -p $1 && cd $1
  fi
}

function bu() {
  if test -f $1; then 
    cp $1 $1.`date +%Y%m%d%H%M%S`.backup;
  else
    echo "$1 does not exist"
  fi
}

function setJavaProxy() {
  if [[ "$http_proxy" == http* ]]; then
	    host=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
}

function fips() {
  if type ip > /dev/null 2>&1 ; then
    local list=$(ip -o -4 addr list | awk '{print $4}' | cut -d'/' -f1 | tr '\n' ',')
  fi
  if type ifconfig > /dev/null 2>&1 ; then
    local list=$(ifconfig | grep "inet " | awk '{print $2}' | sed 's/addr://' | tr '\n' ',')
  fi
  echo ${list%,}
}

function ags() {
  if type ag > /dev/null 2>&1; then
    echo "ag [--support-type] pattern [path]"
    ag --list-file-types | grep $@
  fi
}

function rgs() {
  if type rg > /dev/null 2>&1; then
    echo "rg [-t support-type] pattern [path]"
    rg --type-list | grep $@
  fi
}

# cd
alias u='cd ..'
alias uu='cd ../../'
alias uuu='cd ../../../'
alias uuuu='cd ../../../../'
alias uuuuu='cd ../../../../../'

# greps
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# utils
alias sudo="sudo "
alias h="cd ~"
alias l="ls -thF"
alias ll="ls -lthF"
alias la="ls -lthFA"
alias rm="rm -i"
alias his="history 50"
alias fdperm='find . -type d -exec chmod 755 {} \;'
alias ffperm='find . -type f -exec chmod 644 {} \;'
alias dte='date "+%Y-%m-%d %H:%M:%S"'
alias pth="echo $PATH | tr : \\\\n"
alias lstcp="lsof -i -n -P | grep TCP"
alias mjp=setJavaProxy

if type git > /dev/null 2>&1 ; then
  alias gclone="git clone"
  alias ginit="git init"
  alias gadd="git add"
  alias gmv="git mv"
  alias greset="git reset"
  alias grm="git rm"
  alias gbisect="git bisect"
  alias gbi="git bisect"
  alias ggrep="git grep"
  alias ggp="git grep"
  alias glog="git ll"
  alias gll="git ll"
  alias glast="git last"
  alias glst="git last"
  alias gshow="git show"
  alias gst="git status"
  alias gstash="git stash"
  alias gas="git stash"
  alias gbranch="git branch"
  alias gbr="git branch"
  alias gcheckout="git checkout"
  alias gch="git checkout"
  alias gcommit="git commit"
  alias gcm="git commit"
  alias gdiff="git diff"
  alias gdif="git diff"
  alias gmerge="git merge"
  alias gme="git merge"
  alias grebase="git rebase"
  alias grb="git rebase"
  alias gtag="git tag"
  alias gfetch="git fetch"
  alias gfh="git fetch"
  alias gpull="git pull"
  alias gpl="git pull"
  alias gpush="git push"
  alias gph="git push"
  alias ghelp="git help"
  alias ghp="git help"
	alias grm="git remote"
	alias grmv="git remote -v"
  function gcmm(){  
    if [ -n "$1" ]; then
      git pull && git add --all && git commit -m "$1" && git push
    else
      echo 'Could not run command, please add a commit message! e.g. gcmm "commit message"';
    fi
  }
fi


if type aria2c > /dev/null 2>&1 ; then
  alias aria="aria2c --conf-path=$HOME/.config/aria2/aria2.conf -D"
fi

if type ssh-keygen > /dev/null 2>&1 ; then
  alias sshkeygen="rm -f $HOME/ssh/id_rsa && ssh-keygen -q -t rsa -P "" -N "" -f ~/.ssh/id_rsa"
fi

if type sslocal > /dev/null 2>&1 ; then
  alias ssup="nohup sslocal -c ~/.shadow.json 2>&1 &"
fi

# linux only
if [[ $(uname) == Linux ]]; then
  alias rmrtlan="sudo route del default enp0s31f6"
  alias scrnoff="xset dpms force off "
  if type gvim > /dev/null 2>&1 ; then
    alias vim="gvim -v"
  fi

  if test -f $HOME/.local/bin/virtualenvwrapper.sh; then
    alias vwrapper="source $HOME/.local/bin/virtualenvwrapper.sh"
  fi

  if type xclip > /dev/null 2>&1 ; then
    alias xcp="xclip -selection clipboard"
    alias xcv="xclip -o"
  fi
fi

# mac only
if [[ $(uname) == Darwin ]]; then
  alias perf="top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}'"
  alias rmdstore='sudo find / -name ".DS_Store" -depth -exec rm {} \;'
  alias fip="ipconfig getifaddr en0"
  alias rmdns="sudo networksetup -setdnsservers Wi-Fi Empty"
  alias stdns="sudo networksetup -setdnsservers Wi-Fi 115.159.157.26 115.159.158.38 115.159.96.69 115.159.220.214"
  alias fixbrew="sudo chown -R \"$USER\":admin /usr/local"
  alias bru="brew update && brew upgrade && brew prune"
  
  if test -d $BREW_PREFIX/polipo; then
    alias plpon="brew services start polipo"
    alias plpoff="brew services stop polipo && killall ShadowsocksX"
  fi
  
  if test -f $BREW_BIN/virtualenvwrapper.sh; then
    alias vwrapper="source /usr/local/bin/virtualenvwrapper.sh"
  fi

  if type cf > /dev/null 2>&1 ; then
    alias cfluw="cf login -a https://api.system.aws-usw02-pr.ice.predix.io --sso"
    alias cflja="cf l -a https://api.system.aws-usw02-pr.ice.predix.io -o ivar.chen@ge.com -s dev -u ivar.chen@ge.com -p ivar2018@GE --sso"
  fi

  if test -d ~/Documents/code/shell/bash-profile; then
    function sync_cfg() {
      cp -ru ~/Documents/code/shell/bash-profile/.shell ~/
      cp -ru ~/Documents/code/shell/bash-profile/.vim ~/
      cp -ru ~/Documents/code/shell/bash-profile/.m2 ~/
      cp -ru ~/Documents/code/shell/bash-profile/.gradle ~/
      cp -ru ~/Documents/code/shell/bash-profile/.ivy2 ~/
      cp -ru ~/Documents/code/shell/bash-profile/.sbt ~/
      cp -ru ~/Documents/code/shell/bash-profile/.ammonite ~/
      cp -ru ~/Documents/code/shell/bash-profile/.cabal ~/
      cp -ru ~/Documents/code/shell/bash-profile/.stack ~/
      cp -ru ~/Documents/code/shell/bash-profile/.config ~/
      cp -ru ~/Documents/code/shell/bash-profile/.docker ~/
      cp -ru ~/Documents/code/shell/bash-profile/.bash_profile ~/
      cp -ru ~/Documents/code/shell/bash-profile/.vimrc ~/
      cp -ru ~/Documents/code/shell/bash-profile/.gitconfig ~/
      cp -ru ~/Documents/code/shell/bash-profile/.gitignore ~/
      cp -ru ~/Documents/code/shell/bash-profile/.gemrc ~/
      cp -ru ~/Documents/code/shell/bash-profile/.ghci ~/
      cp -ru ~/Documents/code/shell/bash-profile/.polipo ~/
      cp -ru ~/Documents/code/shell/bash-profile/.tmux.conf ~/
    }
  fi
fi


