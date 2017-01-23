# bash-profile
This is a place we can share the most useful settings of our bash profiles

## .m2
### settings.xml
maven settings configuration

## .sbt
### repositories
scala sbt repositories 

## .Shell/alias.sh
the alias settings file

## .Shell/environments.sh
the files to set up local environments, such as JAVA_HOME, PYTHON_HOME, etc

## .Shell/prompt.sh
provide you a sexy bash prompt in following format:
username on hostname in filepath on git-branch

## .Shell/proxy
proxy settings can be loaded when wifi ssid is BlueSSO, otherise it will not be loaded in bash.
### maually set proxy, requires admin password
```
# set http proxy on both network preference and console
mtproxy
# set http proxy for java if http proxy set
mjp
```
### manually remove proxy, requires admin password
```
rmproxy
```

### display proxy status
```
$ proxystatus
http_proxy=http://3.20.128.6:88
https_proxy=http://3.20.128.6:88
HTTP_PROXY=http://3.20.128.6:88
HTTPS_PROXY=http://3.20.128.6:88
networksetup -getwebproxy Wi-Fi
Enabled: Yes
Server: 3.20.128.6
Port: 88
Authenticated Proxy Enabled: 0
networksetup -getsecurewebproxy Wi-Fi
Enabled: Yes
Server: 3.20.128.6
Port: 88
Authenticated Proxy Enabled: 0
```

### alias
```
#!/usr/bin/env bash

# functions
function qf() { find . -name "$@" -print ;}
function genv() { env | fgrep "$@" ;}
function gps() { ps -ef | fgrep "$@" | fgrep -v fgrep ;}

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
  alias fip="ipconfig getifaddr en0"
  alias cfluw="cf login -o https://api.system.aws-usw02-pr.ice.predix.io"
  alias cflja="cf login -o https://api.system.aws-jp01-pr.ice.predix.io"
fi

```


## .vim/doc
the help doc chinese version

## .vim/settings
the vimrc settings

### .vim/settings/basic.vim
basic settings

### .vim/settings/plugins.vim
plugin settings, using plugin manager: vim-plug and pathogen
installed plugins:
- Plug 'Shougo/neocomplete.vim'
- Plug 'Shougo/vimproc.vim'
- Plug 'Townk/vim-autoclose'
- Plug 'Yggdroot/indentLine'
- Plug 'airblade/vim-gitgutter'
- Plug 'amix/open_file_under_cursor.vim'
- Plug 'eagletmt/neco-ghc'
- Plug 'godlygeek/tabular'
- Plug 'jonathanfilip/vim-lucius'
- Plug 'kien/ctrlp.vim'
- Plug 'mhinz/vim-signify'
- Plug 'navicore/vissort.vim'
- Plug 'neovimhaskell/haskell-vim'
- Plug 'plasticboy/vim-markdown'
- Plug 'rking/ag.vim'
- Plug 'scrooloose/nerdcommenter'
- Plug 'terryma/vim-multiple-cursors'
- Plug 'tpope/vim-fugitive'
- Plug 'tpope/vim-repeat'
- Plug 'tpope/vim-surround'
- Plug 'vim-airline/vim-airline'
- Plug 'vim-airline/vim-airline-themes'
- Plug 'vim-scripts/LargeFile'
- Plug 'w0rp/ale'

### .vim/settings/types.vim
file type settings

### .vim/settings/extends.vim
extra settings




