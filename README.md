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
mtproxy
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




