#!/usr/bin/env bash
# init.sh: single entry point of the shell setup, sourced by ~/.bash_profile and ~/.bashrc.
#
# Load order:
#   every shell (also non-interactive ones such as an agent's `bash -lc`):
#     env.sh                   PATH and exported variables, every OS
#       os/<layer>/env.sh      PATH and variables of one OS or one Linux distribution, sourced by env.sh
#     cf.sh                    cf_* library functions
#     functions.sh             short-named command functions, every OS
#     sync.sh                  sync_cfg
#     os/<layer>/functions.sh  command functions of one OS or one Linux distribution
#     os/<layer>/proxy.sh      proxy switching functions (darwin only so far)
#   interactive shells only:
#     alias.sh                 aliases, every OS
#     os/<layer>/alias.sh      aliases of one OS or one Linux distribution; they override alias.sh
#     prompt.sh                PS1, then vendored bash-complete-partial-path (bash >= 4, GNU sed)
#
# <layer> runs over $_SHELL_OS_LAYERS, the OS layers of this machine (see _shell_detect_os_layers).
# Every os/<layer> file is optional and found by name: adding one needs no change in this file.
#
# Rules for every file above:
#   - sourcing is silent (no stdout/stderr) and only defines or exports things
#   - no forks at load time unless the file header names the exception
#   - whatever changes how a standard command behaves belongs to the interactive-only files
#   - bash 3.2 compatible (macOS /bin/bash); the vendored section of prompt.sh is the exception

_SHELL_DIR="${BASH_SOURCE[0]%/*}"
[[ $_SHELL_DIR == "${BASH_SOURCE[0]}" ]] && _SHELL_DIR=.

# _has <name>: true when <name> is a command, function, or alias. Builtin lookup, no fork.
function _has() {
  command -v "$1" > /dev/null 2>&1
}

# _shell_detect_os_layers: set _SHELL_OS_LAYERS to the OS layers of this machine, most general
# first; a later layer overrides an earlier one. No fork.
#   darwin           $OSTYPE is darwin*
#   linux            $OSTYPE is linux*
#   <distributions>  Linux only, from os-release(5): ID_LIKE from its last name to its first, then ID.
#                    ID=linuxmint with ID_LIKE="ubuntu debian" gives: debian ubuntu linuxmint
#   termux           /data/data/com.termux exists; always the last layer
# _SHELL_OS_RELEASE=<file> replaces /etc/os-release, to try the layers of another distribution.
function _shell_detect_os_layers() {
  local file key="" value="" name id="" like="" distro="" allowed='^[A-Za-z0-9._ -]*$'
  _SHELL_OS_LAYERS=""
  case $OSTYPE in
    darwin*) _SHELL_OS_LAYERS=darwin ;;
    linux*)
      file=${_SHELL_OS_RELEASE:-/etc/os-release}
      [[ -r $file ]] || file=/usr/lib/os-release
      if [[ -r $file ]]; then
        while IFS='=' read -r key value || [[ -n $key ]]; do
          value=${value#[\"\']}
          value=${value%[\"\']}
          case $key in
            ID) id=$value ;;
            ID_LIKE) like=$value ;;
          esac
        done < "$file"
      fi
      # Names become directory names, so only [A-Za-z0-9._-] passes; without glob characters
      # the unquoted split below is safe as well.
      if [[ ! "$id $like" =~ $allowed ]]; then
        id="" like=""
      fi
      # ID_LIKE names the closest relative first: walking "ID ID_LIKE" and prepending each name
      # puts the most general distribution first. A distribution never shadows an OS layer.
      for name in $id $like; do
        if [[ $name == [A-Za-z0-9]* && " linux darwin termux $distro" != *" $name "* ]]; then
          distro="$name $distro"
        fi
      done
      _SHELL_OS_LAYERS="linux${distro:+ ${distro% }}"
      ;;
  esac
  if [[ -d /data/data/com.termux ]]; then
    _SHELL_OS_LAYERS="$_SHELL_OS_LAYERS termux"
  fi
}
_shell_detect_os_layers

for _shell_file in env cf functions sync; do
  . "$_SHELL_DIR/$_shell_file.sh"
done

for _shell_layer in $_SHELL_OS_LAYERS; do
  for _shell_file in functions proxy; do
    if [[ -r "$_SHELL_DIR/os/$_shell_layer/$_shell_file.sh" ]]; then
      . "$_SHELL_DIR/os/$_shell_layer/$_shell_file.sh"
    fi
  done
done

if [[ $- == *i* ]]; then
  # RHEL-family system defaults first, so the files below override them.
  # Debian-family bash reads /etc/bash.bashrc on its own.
  if [[ $OSTYPE == linux* && -f /etc/bashrc ]]; then
    . /etc/bashrc
  fi

  . "$_SHELL_DIR/alias.sh"
  for _shell_layer in $_SHELL_OS_LAYERS; do
    if [[ -r "$_SHELL_DIR/os/$_shell_layer/alias.sh" ]]; then
      . "$_SHELL_DIR/os/$_shell_layer/alias.sh"
    fi
  done
  . "$_SHELL_DIR/prompt.sh"

  if _has zoxide; then
    eval "$(zoxide init bash --cmd z)"
  fi

  if _has jump; then
    eval "$(jump shell --bind=j)"
  fi

  # Termux: keep sshd running so the device stays reachable.
  if [[ -d /data/data/com.termux && -z "$(qps /usr/bin/sshd)" ]]; then
    termux-wake-lock && sshd
  fi
fi

# _SHELL_OS_LAYERS stays set (not exported): `echo "$_SHELL_OS_LAYERS"` shows the layers of this machine.
unset _SHELL_DIR _shell_file _shell_layer
unset -f _shell_detect_os_layers
