#!/usr/bin/env bash

function qf() { find . -iname "$@" -print ;}
function qenv() { env | fgrep "$@" ;}
function qhs() { history | fgrep "$@" | fgrep -v fgrep ;}
function qals() { alias | fgrep "$@" | fgrep -v fgrep ;}
function lsf() { sudo lsof -i -n -P | awk '{print $1,$2,$3,$5,$8,$9}' | grep ${@-""} ;}

function log() {
  local prefix="[$(date '+%Y-%m-%d %H:%M:%S')]"
  echo "$prefix $@" >&2
}

function tail_args() {
  echo "$@" | xargs -n 1 | tail -n +2 | xargs
}

function tgza() {
  local path=$1
  local file=$2
  if [[ "$file" == *tgz || "$file" == *tar.gz ]] && [[ -d $path ]]; then
    echo "tar cvzf $file -C $path ."
    tar cvzf "$file" -C "$path" .
  else
    echo "tgza <src-path> <dest-file>"
    echo "alias for: tar cvzf <dest-file.tgz> -C <src-path> ."
    echo "dest-file is required to be ended with .tgz or tar.gz"
    echo "src-path must be existing"
  fi
}

function tgzx() {
  if [[ $# -ge 2 ]] && [[ "$1" == *tgz || "$1" == *tar.gz ]] && [[ -f "$1" ]]; then
    local tgzFile=$1
    local destPath=$2
    local extractFiles=$(echo $@ | cut -d' ' -f3-)
    echo "tar xvzf $tgzFile -C $destPath $extractFiles"

    mkdir -p "$destPath"
    tar xvzf "$tgzFile" -C "$destPath" $extractFiles
  else
    echo "tgzx <src-file> <dest-path> [extract-files]"
    echo "alias for: tar xvzf <src-file> -C <dest-path> [extract-files]"
    echo "list files in tgz: tar vtf <src-file>"
    echo "src-file must be existing"
  fi
}

function epoch_date() {
  local input=$@
  if [[ $input =~ ^[0-9]{10,}$ ]]; then
    date -d "@${input:0:10}" "+%Y-%m-%d %H:%M:%S" ;
  else
    echo invalid epoch format, current epoch: `date +%s` date: `date "+%Y-%m-%d %H:%M:%S"`
  fi
}

function date_epoch() {
  local input=$@
  if [[ $input =~ ^[1-9][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]).+(20|21|22|23|[0-1][0-9]):[0-5][0-9]:[0-5][0-9]$ ]]; then
    date -d "${input:0}" "+%s" ;
  else
    echo invalid date format, current date: `date "+%Y-%m-%d %H:%M:%S"` epoch: `date +%s`
  fi
}

function bcal() {
  if type bc > /dev/null 2>&1; then
    printf '%.3f\n' "$(echo "scale=3; ${@:-`cat`}" | bc)"
  else
    echo "bc does not exist"
  fi
}

function ffmax() {
  if [[ $1 =~ ^[-+][0-9]+[MG]$ ]] && test -d ${2:-.}; then
    find ${2:-.} -size ${1^^} -exec ls -lh {} \+ | sort -nr | sed "/^total.*$/d" | awk '{print $0}'
  else
    echo "wrong size format, should be e.g +2M,-6G, or input directory not existing"
  fi
}

function qps() {
  if [[ $(uname) == Linux ]]; then
    ps ax -mwww -o pid,ppid,user,pcpu,pmem,args --sort -pcpu,-pmem | grep -v grep | grep --color=auto "$@" ;
  fi
  if [[ $(uname) == Darwin ]]; then
    ps ax -mwww -o pid,ppid,user,pcpu,pmem,args | fgrep -v fgrep | fgrep --color=auto "$@" ;
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
  if type jar > /dev/null 2>&1 && [[ "$@" =~ .+.jar && -f $@ ]]; then
    jar -tf $@
  else
    echo "jar does not exist, or not an existing jar file"
  fi
}

function findInJar() {
  local path=$1
  local file=$2
  if type jar > /dev/null 2>&1 &&  [[ -d $path && -n $file ]]; then
    find $path -type f -iname "*.jar" -print0 | while read -d $'\0' jarFile; do
      if [[ -f "$jarFile" ]]; then
        jar -tf "$jarFile" | while read -r line; do
          if [[ "$line" == *"$file"* ]]; then
            echo "$jarFile : $line"
          fi
        done
      fi
    done
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
function jsonFormat() {
  if type python > /dev/null 2>&1; then
    python -mjson.tool
  else
    echo "python is not found in PATH"
    return 1
  fi
}

function jsonEscape() {
  if type python > /dev/null 2>&1; then
    python -c 'import sys, json; print(json.dumps(sys.stdin.read().strip()))'
  else
    echo "python is not found in PATH"
    return 1
  fi
}

function chext() {
  local path=$1
  local oldExt=$2
  local newExt=$3
  if [[ -d $path && -n $oldExt && -n $newExt ]]; then
    # temprarily navigate to given path
    #pushd $path > /dev/null
    find "$path" -type f -name "*.$oldExt" -exec sh -c 'mv "$0" "${0%.$1}.$2"' {} "$oldExt" "$newExt" \;
    # navigate back 
    #popd > /dev/null
  else 
    echo "chext path oldExt newExt"
    echo "args: path oldExt newExt are required, extension name should not include dot (.) character"
  fi
}

function renamex() {
  local path=$1
  local searchPattern=$2
  local replaceRegex=$3

  if [[ -n $path && -d $path && -n $searchPattern && -n $replaceRegex ]]; then
    find "$path" -type f -name "$searchPattern" -print0 | while IFS= read -r -d '' file; do
      newFile=$(echo "$file" | sed -r "$replaceRegex")
      if [ "$file" != "$newFile" ]; then
        mv -n "$file" "$newFile"
        echo "Renamed $file to $newFile"
      fi
    done
  else 
    echo "renamex path searchPattern replaceRegex"
    echo "args: path searchPattern replaceRegex are required"
    echo "searchPattern is a name pattern for find"
    echo "replaceRegex is an replace regex for sed"
    echo "example: extract number in the middle: \"s/([a-z A-Z \s]+)([0-9]+)(.+)/snapshot_\2.png/\""
    echo "example: remove chinese characters in the middle: \"s/([0-9]+)([^\x00-\xff]+)(\.[0-9 a-z]+)/\1\3/\""
  fi
}


function sync_cfg() {
  if [[ $(pwd) == *bash-profile ]]; then
    cp -ruv .shell ~/
    cp -ruv .vim ~/
    cp -ruv .m2 ~/
    cp -ruv .gradle ~/
    cp -ruv .ivy2 ~/
    cp -ruv .sbt ~/
    cp -ruv .ammonite ~/
    cp -ruv .cabal ~/
    cp -ruv .stack ~/
    cp -ruv .config ~/
    cp -ruv .docker ~/
    cp -ruv .bash_profile ~/
    cp -ruv .vimrc ~/
    cp -ruv .gitconfig ~/
    cp -ruv .gitignore ~/
    cp -ruv .gemrc ~/
    cp -ruv .ghci ~/
    cp -ruv .polipo ~/
    cp -ruv .tmux.conf ~/
  fi
}

# cd
alias u='cd ..'
alias uu='cd ../../'
alias uuu='cd ../../../'
alias uuuu='cd ../../../../'
alias uuuuu='cd ../../../../../'
alias l='cd -'

# greps
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'
alias cpruv='cp -ruv '

# utils
alias sudo="sudo "
alias h="cd ~"
alias ll="ls -lthrF"
alias la="ls -lthrFA"
alias lh="ls -Ad .*"
alias rm="rm -i"
alias his="history 50"
alias fdperm='find . -type d -exec chmod 755 {} \;'
alias ffperm='find . -type f -exec chmod 644 {} \;'
alias pth="echo $PATH | tr : \\\\n"

if type exa > /dev/null 2>&1 ; then
  alias ll="exa -l --time-style=long-iso --sort=modified"
  alias lh="exa -lh --time-style=long-iso --sort=modified"
  alias la="exa -la --time-style=long-iso --sort=modified"
fi

if type git > /dev/null 2>&1 ; then
  alias gadd="git add"
  alias gbisect="git bisect"
  alias gbranch="git branch"
  alias gcheckout="git checkout"
  alias gclone="git clone"
  alias gcm="git commit"
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
  alias gstatus="git status"
  alias gstash="git stash"
  alias gtag="git tag"
fi


if type aria2c > /dev/null 2>&1 ; then
  alias aria="aria2c --conf-path=$HOME/.config/aria2/aria2.conf -D"
fi

if type ssh-keygen > /dev/null 2>&1 ; then
  alias sshkeygen="rm -f $HOME/.ssh/id_* && ssh-keygen -q -t rsa -N '' -f $HOME/.ssh/id_rsa"
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
  if test -z $keypass; then
    keytool -importcert -keystore ${keystore} -storepass ${storepass} -file ${file} -alias ${alias} -keypass ${keypass}
  else
    keytool -importcert -keystore ${keystore} -storepass ${storepass} -file ${file} -alias ${alias}
  fi
}
fi

if type openssl > /dev/null 2>&1 && type sed > /dev/null 2>&1; then
function cf_download_cert() {
  local remoteHost=${1}
  local remotePort=${2:-443}
  echo | openssl s_client -connect ${remoteHost}:${remotePort} 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
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
    alias spup="supervisord -c $HOME/.supervisord_server.conf && supervisorctl status"
    alias spdown="supervisorctl shutdown"
  fi

  if type systemctl > /dev/null 2>&1 ; then
    alias lsvc="systemctl list-units --type=service"
  fi

fi

# mac only
if [[ $(uname) == Darwin ]]; then
  alias rrc="source $HOME/.bash_profile"
  alias perf="top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}'"
  alias rmdstore='find . -name ".DS_Store" -depth -exec rm {} \;'
  alias fip="ipconfig getifaddr en0"
  alias fixbrew="sudo chown -R \"$USER\":admin /usr/local"
  alias bru="brew update && brew upgrade && brew cleanup"

  if type trash > /dev/null 2>&1 ; then
    alias rm="trash -v "
  fi

  if test -d $BREW_PREFIX/polipo; then
    alias plpon="brew services start polipo"
    alias plpoff="brew services stop polipo ; killall ShadowsocksX"
  fi

  if test -f $BREW_BIN/virtualenvwrapper.sh; then
    alias vwrapper="source /usr/local/bin/virtualenvwrapper.sh"
  fi

  if type supervisorctl > /dev/null 2>&1 ; then
    alias spup="open /Applications/ShadowsocksX.app && supervisord -c $HOME/.supervisord_mac.conf && supervisorctl status"
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

fi

# raspberrypi only
if [[ $(uname -a) == *rasp* ]]; then
  if type supervisorctl > /dev/null 2>&1 ; then
    alias spup="supervisord -c $HOME/.supervisord_rasp.conf && supervisorctl status"
    alias spdown="supervisorctl shutdown"
    alias cputemp='bcal "$(cat /sys/class/thermal/thermal_zone0/temp)/1000"'
  fi
fi


# termux only
if [[ $(uname -a) == *Android* ]]; then
  alias sshdup="termux-wake-lock && sshd"
fi
