# bash-profile
This is a place we can share the most useful settings of our bash profiles

## brew ls

```
$ brew ls
ab				gtk+3				ntfs-3g
adns				h2				oniguruma
ammonite-repl			harfbuzz			openjpeg
annie				haskell-stack			openssl
ant				hicolor-icon-theme		openssl@1.1
apache-spark			highlight			p11-kit
apr				htop				p7zip
apr-util			httpie				pandoc
aria2				icdiff				pango
atk				icu4c				pcre
autoconf			iftop				perl
automake			imagemagick			pgcli
awscli				infer				pidof
axel				isl				pinentry
bash				jemalloc			pip-completion
bash-completion			jpeg				pixman
binutils			jq				pkg-config
bmon				jump				polipo
boost				kafka				poppler
brew-cask-completion		lame				postgresql
cabal-install			leptonica			proctools
cabextract			libarchive			protobuf
cairo				libassuan			pv
calc				libepoxy			python
cf-cli				libevent			python3
chezscheme			libffi				python@2
clojure				libgcrypt			q
cmake				libgpg-error			qemu
confuse				libidn2				qt
consul				libksba				readline
coreutils			libmpc				redis
coursier			libpng				ripgrep
cscope				libpq				rlwrap
diffutils			libspectre			ruby
doxygen				libtasn1			ruby-completion
ffmpeg				libtermkey			s3cmd
findutils			libtiff				sbt
fontconfig			libtool				scala
freetype			libunistring			scons
fribidi				libusb				sdl2
gawk				libuv				shared-mime-info
gcc				libvterm			shml
gd				libyaml				snappy
gdbm				libzip				sphinx-doc
gdk-pixbuf			little-cms2			sqlite
gem-completion			llvm				st
gettext				lua				the_silver_searcher
ghc				luajit				tldr
ghc@8.0				m-cli				tmux
ghostscript			macvim				tree
gist				markdown			unibilium
git				maven				unixodbc
glew				maven-completion		unrar
glib				memcached			vagrant-completion
gmp				mgba				vim
gnu-getopt			mitmproxy			webp
gnu-indent			mpfr				wget
gnu-sed				mpg123				whois
gnu-tar				msgpack				winetricks
gnutls				msodbcsql			x264
go				mssql-tools			xvid
gobject-introspection		ncurses				xz
godep				neo4j				yank
gradle				neovim				yarn
graphite2			nettle				zlib
graphviz			nmap				zookeeper
groovysdk			node
gsettings-desktop-schemas	npth
```

## brew cask ls

```
appcleaner                       mpv                              suspicious-package
basictex                         osxfuse                          texmacs
betterzipql                      postman                          unrarx
blueharvest                      qlcolorcode                      vagrant
caffeine                         qlmarkdown                       virtualbox
etcher                           qlprettypatch                    virtualbox-extension-pack
filezilla                        qlstephen                        visual-studio-code
firefox                          quicklook-csv                    visualvm
google-chrome                    quicklook-json                   vnc-viewer
intellij-idea-ce                 racket                           vox
iterm2                           rar                              webpquicklook
java                             shadowsocksx                     xquartz
karabiner-elements               spectacle
macdown                          squirrel
```

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

#### manually remove proxy, requires admin password

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


