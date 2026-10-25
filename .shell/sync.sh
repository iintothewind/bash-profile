#!/usr/bin/env bash

function sync_cfg() {
  if [[ $(pwd) == *bash-profile ]]; then
    # Git Bash/MSYS2 set $HOME to a Windows path (C:\Users\...); rsync parses
    # the leading C: as a remote host, so normalize HOME to the POSIX path
    # (/c/Users/ivar) so `~/` is a local destination. cygpath exists only on
    # MSYS; Linux/macOS leave HOME untouched.
    command -v cygpath > /dev/null 2>&1 && HOME=$(cygpath -u "$HOME")
    local items=(
      .shell
      .vim
      .gitattributes
      .gitconfig
      .gitignore
      .ideavimrc
      .tmux.conf
      .vimrc
    )
    # Sync each subdirectory under .config individually so --delete only ever
    # touches that subdir, never unrelated entries in ~/.config (e.g. other
    # apps' configs on Linux).
    for item in .config/*/; do
      rsync -a --itemize-changes --delete "${item%/}" ~/
    done
    for item in "${items[@]}"; do
      rsync -a --itemize-changes --delete "$item" ~/
    done

    # .bash_profile: 直接替换
    cp -f .bash_profile ~/.bash_profile

    # .bashrc: 保留标记前的内容，每次同步把标记后替换为最新 .bash_profile；无标记则末尾追加
    local marker='# synced from bash-profile'
    if [[ -f ~/.bashrc ]] && grep -qF "$marker" ~/.bashrc; then
      local head
      head=$(sed "/^$marker\$/,\$d" ~/.bashrc)
      { printf '%s\n' "$head"; printf '%s\n' "$marker"; cat .bash_profile; } > ~/.bashrc
    else
      { printf '\n%s\n' "$marker"; cat .bash_profile; } >> ~/.bashrc
    fi
  fi
}
