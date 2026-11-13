#!/usr/bin/env bash
# sync.sh: sync_cfg deploys the dotfiles of this repo into $HOME.
# Loaded by init.sh in every shell. It is also the bootstrap on a fresh machine
# (`source .shell/sync.sh && sync_cfg`), so it must not use helpers from init.sh.

# sync_cfg: run from the repo root; the directory name has to end with bash-profile
function sync_cfg() {
  if [[ $PWD != *bash-profile ]]; then
    echo "sync_cfg must run from the bash-profile repo root, current directory: $PWD" >&2
    return 1
  fi

  # Git Bash/MSYS2 may set HOME to a Windows path (C:\Users\...), and rsync reads the leading C:
  # as a remote host. cygpath exists only there; Linux/macOS use HOME as it is.
  local dest=$HOME
  if command -v cygpath > /dev/null 2>&1; then
    dest=$(cygpath -u "$HOME")
  fi

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
  local item
  # One rsync per subdirectory of .config, so --delete never touches other apps' configs in ~/.config.
  for item in .config/*/; do
    rsync -a --itemize-changes --delete "${item%/}" "$dest/.config"
  done
  for item in "${items[@]}"; do
    rsync -a --itemize-changes --delete "$item" "$dest/"
  done

  cp -f .bash_profile "$dest/.bash_profile"

  # ~/.bashrc: keep everything before the marker, replace everything after it with .bash_profile;
  # without a marker, append marker + .bash_profile.
  local marker='# synced from bash-profile'
  if [[ -f "$dest/.bashrc" ]] && grep -qF "$marker" "$dest/.bashrc"; then
    local head
    head=$(sed "/^$marker\$/,\$d" "$dest/.bashrc")
    {
      printf '%s\n' "$head"
      printf '%s\n' "$marker"
      cat .bash_profile
    } > "$dest/.bashrc"
  else
    {
      printf '\n%s\n' "$marker"
      cat .bash_profile
    } >> "$dest/.bashrc"
  fi
}
