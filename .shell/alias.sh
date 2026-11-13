#!/usr/bin/env bash
# alias.sh: aliases, and nothing else.
# Loaded by init.sh in interactive shells only, after functions.sh. Scripts and agent shells never
# see these, which is why overriding standard commands (rm, grep, ls, sudo, vim) is fine here.
# Contract:
#   - aliases only; whatever needs arguments or logic is a function in functions.sh
#   - tool-specific aliases sit inside `if _has <tool>`
#   - an alias for one OS or one Linux distribution only goes to os/<layer>/alias.sh, not here

# --- navigation -------------------------------------------------------------

alias u='cd ..'
alias uu='cd ../../'
alias uuu='cd ../../../'
alias uuuu='cd ../../../../'
alias uuuuu='cd ../../../../../'
alias l='cd -'
alias h='cd ~'

# --- standard command defaults ------------------------------------------------

alias sudo='sudo ' # trailing space: the word after sudo is alias-expanded too
alias rm='rm -i'
alias grep='grep --color=auto'
alias cpruv='cp -ruv '

# --- listing ------------------------------------------------------------------

alias ll='ls -lthrF'
alias la='ls -lthrFA'
alias lh='ls -Ad .*'

if _has eza; then
  alias ll='eza -l --time-style=long-iso --sort=modified'
  alias lh='eza -lh --time-style=long-iso --sort=modified'
  alias la='eza -la --time-style=long-iso --sort=modified'
fi

# --- misc ---------------------------------------------------------------------

alias his='history 50'
alias fdperm='find . -type d -exec chmod 755 {} \;'
alias ffperm='find . -type f -exec chmod 644 {} \;'
alias pth='echo $PATH | tr : \\n'

# --- tools --------------------------------------------------------------------

if _has git; then
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

if _has aria2c; then
  alias aria="aria2c --conf-path=$HOME/.config/aria2/aria2.conf -D"
fi
