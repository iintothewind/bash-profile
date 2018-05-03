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

function sync_cfg() {
  if [[ $(pwd) == *bash-profile ]]; then
    cp -r .shell ~/
    cp -r .vim ~/
    cp -r .m2 ~/
    cp -r .gradle ~/
    cp -r .ivy2 ~/
    cp -r .sbt ~/
    cp -r .ammonite ~/
    cp -r .cabal ~/
    cp -r .stack ~/
    cp -r .config ~/
    cp -r .docker ~/
    cp -r .bash_profile ~/
    cp -r .vimrc ~/
    cp -r .gitconfig ~/
    cp -r .gitignore ~/
    cp -r .gemrc ~/
    cp -r .ghci ~/
    cp -r .polipo ~/
    cp -r .tmux.conf ~/
    cp -r .supervisord.conf ~/
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
  alias ssvrup="ssserver -c $HOME/.shadowsocks.json -d start"
  alias ssvrdown="ssserver -c $HOME/.shadowsocks.json -d stop"
  alias sslcup="sslocal -c $HOME/.shadowsocks.json -d start"
  alias sslcdown="sslocal -c $HOME/.shadowsocks.json -d stop"
fi

if type vagrant > /dev/null 2>&1 ; then
  alias vinit="vagrant init"
  alias vup="vagrant up"
  alias vssh="vagrant ssh"
  alias vsuspend="vagrant suspend"
  alias vresume="vagrant resume"
  alias vreload="vagrant load"
  alias vhalt="vagrant halt"
  alias vport="vagrant port"
  alias vbox="vagrant box"
  alias vdestroy="vagrant destroy"
  alias vpackage="vagrant package"
  alias vpush="vagrant push"
fi

if type VBoxManage > /dev/null 2>&1 ; then
  alias vlsvm="VBoxManage list vms"
  alias vvminfo="VBoxManage showvminfo"
fi

if type keytool > /dev/null 2>&1 && [[ $JAVA_HOME != "" ]]; then 
  function list_cert() {
    local keystore=${1:-$JAVA_HOME/jre/lib/security/cacerts}
    local storepass=${2:-changeit}
    keytool -list -keystore $keystore -storepass $storepass 
  }

  function import_cert() {
    local file=${1}
    local alias=${2}
    local keypass=${3}
    local keystore=${4:-$JAVA_HOME/jre/lib/security/cacerts}
    local storepass=${5:-changeit}
    if test $keypass; then
      keytool -importcert -keystore ${keystore} -storepass ${storepass} -file ${file} -alias ${alias} -keypass ${keypass}
    else
      keytool -importcert -keystore ${keystore} -storepass ${storepass} -file ${file} -alias ${alias}
    fi
  }
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
  alias clean-cask="pushd /usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask && git prune && popd"
  alias clean-versions="pushd /usr/local/Homebrew/Library/Taps/caskroom/homebrew-versions && git prune && popd"
  
  if test -d $BREW_PREFIX/polipo; then
    alias plpon="brew services start polipo"
    alias plpoff="brew services stop polipo && killall ShadowsocksX"
  fi
  
  if test -f $BREW_BIN/virtualenvwrapper.sh; then
    alias vwrapper="source /usr/local/bin/virtualenvwrapper.sh"
  fi

  if type supervisorctl > /dev/null 2>&1 ; then
    alias spup="supervisord -c $HOME/.supervisord.conf && supervisorctl status"
    alias spdown="supervisorctl shutdown && killall ShadowsocksX"
  fi

  if type cf > /dev/null 2>&1 ; then
    alias cfluw="cf login -a https://api.system.aws-usw02-pr.ice.predix.io --sso"
    alias cflja="cf l -a https://api.system.aws-usw02-pr.ice.predix.io -o ivar.chen@ge.com -s dev -u ivar.chen@ge.com -p ivar2018@GE --sso"
  fi
fi


