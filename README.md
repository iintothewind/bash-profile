# bash-profile
This is a place we can share the most useful settings of our bash profiles

## install gnu bash

```
brew install xz coreutils
gdircolors --print-database > ~/.dir_colors
brew install bash bash-completion
sudo sh -c 'echo "/usr/local/bin/bash" >> /etc/shells'
chsh -s /usr/local/bin/bash
```

## brew ls

```
$ brew ls
activemq ammonite-repl ant aom aria2 autoconf
automake bash bash-completion bat binutils bmon
boost cabal-install cairo chezscheme cliclick cmake
confuse coreutils coursier cscope diffutils dos2unix
elasticsearch eslint expect fd ffmpeg findutils
flac fontconfig freetype frei0r fribidi fselect
gawk gcc gd gdbm gettext ghc
giflib git glib gmp gnu-getopt gnu-indent
gnu-sed gnu-tar gnutls go gobject-introspection gradle
graphicsmagick graphite2 graphviz groovysdk grunt-cli gts
h2 harfbuzz haskell-stack highlight htop httpie
icu4c ilmbase imagemagick isl jasper jemalloc
jpeg jq jsonnet jump lame leptonica
libaacs libarchive libass libbluray libcaca libde265
libepoxy libevent libffi libgcrypt libgpg-error libheif
libidn2 libmpc libogg libomp libpng libsamplerate
libsndfile libsoxr libssh2 libtasn1 libtermkey libtiff
libtool libunistring libuv libvorbis libvpx libvterm
libyaml libzip little-cms2 llvm lua lua@5.1
luajit lzo makedepend maven maven-completion mgba
mill mitmproxy mosh mpfr mpg123 mpv
msgpack mujs ncurses neovim netpbm nettle
nmap node ntfs-3g oniguruma opencore-amr openexr
openjpeg openssl opus p11-kit p7zip pandoc
pcre pcre2 perl pixman pkg-config polipo
prettyping protobuf pv python python@2 q
qt readline redis ripgrep rtmpdump rubberband
ruby sbt scala sdl2 shared-mime-info snappy
speex sphinx-doc sqlite swig telnet tesseract
testenv the_silver_searcher theora tldr tmux trash
uchardet unbound unibilium vapoursynth vert.x vim
webp wget x264 x265 xvid xz
yank youtube-dl zimg zlib
```

## brew cask ls

```
appcleaner                  macdown                     shadowsocksx
basictex                    macs-fan-control            simple-comic
caffeine                    macvim                      soapui
easyfind                    mpv                         spectacle
eclipse-java                osxfuse                     tigervnc-viewer
firefox                     postman                     vagrant
google-chrome               qlcolorcode                 virtualbox
google-chrome-canary        qlmarkdown                  virtualbox-extension-pack
intellij-idea-ce            qlmobi                      visual-studio-code
iterm2                      qlprettypatch               visualvm
java                        qlstephen                   webpquicklook
java8                       quicklook-csv               xquartz
karabiner-elements          quicklook-json              popclip
keka                        quicksilver                 snip
manico
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
# recommend NOPASSWD in /etc/sudoers
Defaults	env_reset,pwfeedback
%admin  ALL = (root) NOPASSWD: /usr/sbin/networksetup

# set local proxy in shell
$ localProxy

# set mac system proxy, require admin passwd, require http host and port if http_proxy environment vaiable not set
$ sysProxy

# remove proxy in shell, also remove system proxy if system proxy enabled
$ rmProxy

# display proxy status
$ pxys
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
