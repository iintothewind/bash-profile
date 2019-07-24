#!/usr/bin/env bash

function qf() { find . -name "$@" -print ;}
function qenv() { env | fgrep "$@" ;}
function qhs() { history | fgrep "$@" | fgrep -v fgrep ;}
function qals() { alias | fgrep "$@" | fgrep -v fgrep ;}
function lsf() { lsof -i -n -P | awk '{print $1,$2,$3,$5,$8,$9}' | grep ${@-""} ;}

function log() {
  local prefix="[$(date '+%Y-%m-%d %H:%M:%S')]"
  echo "$prefix $@" >&2
}

function epoch_date() {
  if [ ! -n "$1" ]; then
    echo input epoch: `date +%s` date: `date "+%Y-%m-%d %H:%M:%S"`
  else
    date -d "@$@" "+%Y-%m-%d %H:%M:%S" ;
  fi
}

function bcal() {
  if type bc > /dev/null 2>&1; then
    printf '%.3f\n' "$(echo "scale=3; $@" | bc)"
  else
    echo "bc does not exist"
  fi
}

function date_epoch() {
  if [ ! -n "$1" ]; then
    echo input date: `date "+%Y-%m-%d %H:%M:%S"` epoch: `date +%s`
  else
    date -d "$@" "+%s" ;
  fi
}

function ffmax() {
  if [[ $1 =~ ^[-+][0-9]+[MG]$ ]] && test -d ${2:-.}; then
    find ${2:-.} -size ${1^^} -exec ls -lh {} \+ | sort -nr | sed "/^total.*$/d" | awk '{print $1,$3,$5,$9}'
  else
    echo "wrong size format, should be e.g +2M,-6G, or input directory not existing"
  fi
}

function qps() {
  if [[ $(uname) == Linux ]]; then
    ps ax -o pid,ppid,user,pcpu,pmem,args --sort -pcpu,-pmem | grep -v grep | grep --color=auto "$@" ;
  fi
  if [[ $(uname) == Darwin ]]; then
    ps ax -rmwwwd -o pid,ppid,user,pcpu,pmem,args | fgrep -v fgrep | fgrep --color=auto "$@" ;
  fi
}

function catdup() {
  if test -f $@ && [[ `file $@` =~ .+.text ]]; then
    cat $@ | sort | uniq -dc
  else
    echo "input file does not exist or not a text file"
  fi
}

function md() {
  if [ ! -n "$1" ]; then
    echo "enter a name for this folder"
  elif [ -d $1 ]; then
    echo "$1 already exists"
  else
    mkdir -p $1 && cd $1 && pwd
  fi
}

function bu() {
  if test -f $1; then
    cp $1 $1.`date +%Y%m%d%H%M%S`.backup;
  else
    echo "$1 does not exist"
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

function mvn_skiptest() {
  if type mvn > /dev/null 2>&1; then
    mvn -Dmaven.test.skip=true "$@" ;
  else
    echo "mvn does not exist"
  fi
}

function qjps() {
  if type jps > /dev/null 2>&1; then
    jps -v | fgrep "$@" | fgrep -v fgrep ;
  else
    echo "jps does not exist"
  fi
}

function lsjar() {
  if type jar > /dev/null 2>&1 && [[ "$@" =~ .+.jar ]] && test -f $@; then
    jar -tf $@
  else
    echo "jar does not exist, or not an existing jar file"
  fi
}

function ags() {
  if type ag > /dev/null 2>&1; then
    echo "ag [--support-type] pattern [path]"
    if [[ $@ != "" ]]; then
      ag --list-file-types | grep $@
    else
      echo "please give a file extension to search the support type"
    fi
  else
    echo "ag does not exist"
  fi
}

function rgs() {
  if type rg > /dev/null 2>&1; then
    echo "rg [-t support-type] pattern [path]"
    if [[ $@ != "" ]]; then
      rg --type-list | grep $@
    else
      echo "please give a file extension to search the support type"
    fi
  else
    echo "rg does not exist"
  fi
}

# used after a pipe, for example: echo '{ "k": "v"}' | cf_jsonfmt
function jsonfmt() {
  if type python > /dev/null 2>&1; then
    python -mjson.tool
  else
    echo "python is not found in PATH"
    return 1
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
alias lh="ls -Ad .*"
alias rm="rm -i"
alias his="history 50"
alias fdperm='find . -type d -exec chmod 755 {} \;'
alias ffperm='find . -type f -exec chmod 644 {} \;'
alias pth="echo $PATH | tr : \\\\n"

if type git > /dev/null 2>&1 ; then
  alias gadd="git add"
  alias gbisect="git bisect"
  alias gbranch="git branch"
  alias gcheckout="git checkout"
  alias gclone="git clone"
  alias gcommit="git commit"
  alias gdif="git diff HEAD^ HEAD"
  alias gdiff="git diff"
  alias gdt="git difftool"
  alias gfetch="git fetch"
  alias ghelp="git help"
  alias ginit="git init"
  alias gll="git log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(cyan)<%an>%Creset' --abbrev-commit --date=relative"
  alias glast="gll -1"
  alias gmerge="git merge"
  alias gmv="git mv"
  alias gpull="git pull"
  alias gsubmodule="git submodule update --init --recursive"
  alias gpush="git push"
  alias grebase="git rebase"
  alias greset="git reset"
  alias gresethard="git reset --hard HEAD"
  alias grmv="git remote -v"
  alias gshow="git show"
  alias gst="git status"
  alias gstash="git stash"
  alias gtag="git tag"
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

if type ssserver > /dev/null 2>&1 ; then
  alias ssvrup="ssserver -c $HOME/.shadowsocks.json -d start"
  alias ssvrdown="ssserver -c $HOME/.shadowsocks.json -d stop"
fi

if type sslocal > /dev/null 2>&1 ; then
  alias sslcup="sslocal -c $HOME/.shadowsocks.json -d start"
  alias sslcdown="sslocal -c $HOME/.shadowsocks.json -d stop"
fi

if test -f /usr/local/kcptun/server_linux_amd64 && test -f /usr/local/kcptun/server-config.json; then
  alias kcpsrvup="/usr/local/kcptun/server_linux_amd64 -c /usr/local/kcptun/server-config.json"
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
  alias rrc="source $HOME/.bashrc"
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

  if type supervisorctl > /dev/null 2>&1 ; then
    alias spup="supervisord -c $HOME/.supervisord.conf && supervisorctl status"
    alias spdown="supervisorctl shutdown"
  fi
fi

# mac only
if [[ $(uname) == Darwin ]]; then
  alias rrc="source $HOME/.bash_profile"
  alias perf="top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}'"
  alias rmdstore='sudo find / -name ".DS_Store" -depth -exec rm {} \;'
  alias fip="ipconfig getifaddr en0"
  alias fixbrew="sudo chown -R \"$USER\":admin /usr/local"
  alias bru="brew update && brew upgrade && brew cleanup"
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
    alias spup="open /Applications/ShadowsocksX.app && supervisord -c $HOME/.supervisord.conf && supervisorctl status"
    alias spdown="supervisorctl shutdown ; killall ShadowsocksX"
  fi

  if type minidlnad > /dev/null 2>&1 ; then
    alias rsminidlna="brew services stop minidlna && rm -f ~/.config/minidlna/files.db && brew services start minidlna"
  fi

  function setdns() {
    if test -f /bin/launchctl ; then
      networksetup -listallnetworkservices | tail -n +2 | while read network_service; do
        sudo networksetup -setdnsservers "$network_service" "$@"
      done
    fi
  }

  function unsetdns() {
    if test -f /bin/launchctl ; then
      networksetup -listallnetworkservices | tail -n +2 | while read network_service; do
        sudo networksetup -setdnsservers "$network_service" "Empty"
      done
    fi
  }

  function killDaemons() {
    if test -f /bin/launchctl ; then
      sudo launchctl remove "com.absolute.abtsvcd"
      sudo launchctl remove "com.absolute.ctesservice"
      sudo launchctl remove "com.absolute.ctesservice.avp"
      sudo launchctl remove "com.absolute.ctesservice.hdc"
      sudo launchctl remove "com.absolute.rpcnet"
      sudo launchctl remove "com.ar.jarx"
      sudo launchctl remove "com.beyondtrust.pbmac.pbmacd"
      sudo launchctl remove "com.jamf.management.daemon"
      sudo launchctl remove "com.jamfsoftware.jamf.daemon"
      sudo launchctl remove "com.jamfsoftware.startupItem"
      sudo launchctl remove "com.jamfsoftware.task.Every 15 Minutes"
      sudo launchctl remove "com.tanium.taniumclient"
      sudo launchctl remove "com.tanium.trace.recorder"
    fi
  }

function checkCaskUpgrade() {
  if test -d /usr/local/Caskroom; then
    for c in `ls /usr/local/Caskroom `; do
      INFO=`brew cask info $c`
      LATEST=`echo $INFO | head -n 1 | awk '{print $2}'`
      if [ `brew cask info $c | tail -n +2 | grep $LATEST | wc -l | awk '{print $1}'` -eq 0 ]; then
        echo $c
      fi
    done
  fi
}
fi
