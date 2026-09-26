#!/usr/bin/env bash

function sync_cfg() {
  if [[ $(pwd) == *bash-profile ]]; then
    local items=(
      .config
      .shell
      .vim
      .gitattributes
      .gitconfig
      .gitignore
      .ideavimrc
      .tmux.conf
      .vimrc
    )
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
