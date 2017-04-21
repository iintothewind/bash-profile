#!/usr/bin/env bash

# functions
function qf() { find . -name "$@" -print ;}
function genv() { env | fgrep "$@" ;}
function gps() { ps -ef | fgrep "$@" | fgrep -v fgrep ;}
function ghs() { history | fgrep "$@" | fgrep -v fgrep ;}

function setJavaProxy {
  if [[ "$HTTP_PROXY" == http* ]]; then
	    host=$(echo $HTTP_PROXY | cut -d'/' -f3 | cut -d':' -f1)
	    port=$(echo $HTTP_PROXY | cut -d'/' -f3 | cut -d':' -f2)
	    export JAVA_OPTS="-Dhttp.proxyHost=$host -Dhttp.proxyPort=$port -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
  fi
}

# greps
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# utils
alias sudo="sudo "
alias l="ls -thF"
alias ll="ls -lthF"
alias la="ls -lthFA"
alias lx="ls -lXB"
alias md="mkdir "
alias rm="rm -i"
alias h="history 50"
alias fdperm='find . -type d -exec chmod 755 {} \;'
alias ffperm='find . -type f -exec chmod 644 {} \;'
alias dte="date \"+%Y-%m-%d %H:%M:%S\""
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
  alias gstatus="git status"
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
fi

# linux only
if [[ $(uname) == Linux ]]; then
  alias vim="gvim -v"
  alias xcp="xclip -selection clipboard"
  alias xcv="xclip -o"
  alias rmrtlan="sudo route del default enp0s31f6"
  alias scrnoff="xset dpms force off "
  alias ssup="nohup sslocal -c ~/.shadow.json 2>&1 &"
fi

# mac only
if [[ $(uname) == Darwin ]]; then
  alias perf="top -l 1 -s 0 | awk ' /Processes/ || /PhysMem/ || /Load Avg/{print}'"
  alias fixbrew="sudo chown -R \"$USER\":admin /usr/local"
  alias rmdstore='find . -name ".DS_Store" -depth -exec rm {} \;'
  alias fip="ipconfig getifaddr en0"
  alias rmdns="sudo networksetup -setdnsservers Wi-Fi Empty"
  alias stdns="sudo networksetup -setdnsservers Wi-Fi 115.159.157.26 115.159.158.38 115.159.96.69 115.159.220.214"
  alias cfluw="cf login -o https://api.system.aws-usw02-pr.ice.predix.io"
  alias cflja="cf login -o https://api.system.aws-jp01-pr.ice.predix.io"
fi


