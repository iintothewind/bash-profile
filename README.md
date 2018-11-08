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
ammonite-repl		glib			libunistring		polipo
annie			gmp			libuv			proctools
apache-spark		gnu-getopt		libvterm		protobuf
aria2			gnu-indent		libyaml			pv
autoconf		gnu-sed			libzip			python
automake		gnu-tar			lua			python3
axel			gnutls			lua@5.1			python@2
bash			go			luajit			q
bash-completion		gobject-introspection	macvim			qt
bat			gradle			maven			readline
binutils		graphite2		mgba			redis
boost			h2			mitmproxy		ripgrep
brew-cask-completion	harfbuzz		mpfr			ruby
cairo			haskell-stack		mpg123			sbt
cap-completion		hh			mpv			scala
chezscheme		highlight		msgpack			scipy
cmake			htop			mujs			sdl2
coreutils		icu4c			nasm			sqlite
cscope			imagemagick		neovim			st
diffutils		isl			nettle			texi2html
docker-completion	jemalloc		nmap			the_silver_searcher
doxygen			jpeg			node			tldr
ext4fuse		jump			ntfs-3g			tmux
fd			lame			numpy			tree
ffmpeg			libass			openssl			typescript
findutils		libepoxy		p11-kit			unibilium
fontconfig		libevent		p7zip			vim
freetype		libffi			pandoc			webp
fribidi			libmpc			pcre			x264
gawk			libpng			pcre2			xsv
gcc			libtasn1		perl			xvid
gdbm			libtermkey		pip-completion		xz
gettext			libtiff			pixman			yank
git			libtool			pkg-config		yasm
```

## brew cask ls

```
basictex                    intellij-idea-ce            qlstephen                   the-unarchiver
betterzipql                 iterm2                      quicklook-csv               vagrant
caffeine                    java8                       quicklook-json              virtualbox
cheatsheet                  karabiner-elements          quicksilver                 virtualbox-extension-pack
etcher                      macdown                     racket                      visual-studio-code
filezilla                   osxfuse                     shadowsocksx
google-chrome               qlmarkdown                  spectacle
haskell-platform            qlprettypatch               suspicious-package          simple-comic
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
