# bash-profile
This is a place we can share the most useful settings of our bash profiles

## bash settings
### .Shell/alias.sh
the alias settings file

### .Shell/environments.sh
the files to set up local environments, such as JAVA_HOME, PYTHON_HOME, etc

### .Shell/prompt.sh
provide you a sexy bash prompt in following format:
username on hostname in filepath on git-branch

### .Shell/proxy
proxy settings can be loaded when wifi ssid is BlueSSO, otherise it will not be loaded in bash.
#### maually set proxy, requires admin password

```
# set http proxy on both network preference and console
mtgeproxy
# set http proxy for java if http proxy set
mjp
```
#### manually remove proxy, requires admin password

```
rmproxy
```

#### display proxy status

```
$ pxys
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
many useful aliases in .shell/alias.sh



## vim settings

### .vim/doc
the help doc chinese version

### .vim/settings
the vimrc settings

### .vim/settings/basic.vim
basic settings

### .vim/settings/plugins.vim

```
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Valloric/YouCompleteMe', {'do': './install.py'}
Plug 'airblade/vim-gitgutter'
Plug 'derekwyatt/vim-scala', {'for': 'scala'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'jonathanfilip/vim-lucius'
Plug 'kien/ctrlp.vim'
Plug 'luochen1990/rainbow'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'navicore/vissort.vim'
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/LargeFile'
Plug 'w0rp/ale', {'tag': 'v1.4.0'}
Plug 'ybian/smartim'
```

### .vim/settings/types.vim
file type settings

### .vim/settings/extends.vim
extra settings


## java settings

### .m2 settings.xml
maven settings configuration

### .ivy2 ivysettings.xml
ivy settings

### .gradle
gradle settings

### .sbt repositories
scala sbt repositories 


