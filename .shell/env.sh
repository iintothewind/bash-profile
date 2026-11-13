#!/usr/bin/env bash
# env.sh: PATH and exported environment variables, every OS.
# Loaded by init.sh (and only by it: it uses _SHELL_DIR and _SHELL_OS_LAYERS) in every shell,
# so it has to stay fast, silent and idempotent:
#   - no forks at load time; exceptions are named in the header of the os/<layer>/env.sh concerned
#   - PATH entries go through _path_append/_path_prepend (existing dirs only, no duplicates)
#   - checks that depend on PATH (_has <tool>) come after the PATH section
#   - PATH and variables of one OS or one Linux distribution go to os/<layer>/env.sh, loaded at the
#     end of the PATH section below, while _path_append/_path_prepend still exist

# _path_append <dir> / _path_prepend <dir>: add an existing <dir> to PATH unless already listed.
function _path_append() {
  if [[ -d "$1" && ":$PATH:" != *":$1:"* ]]; then
    PATH="$PATH:$1"
  fi
}

function _path_prepend() {
  if [[ -d "$1" && ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

# --- PATH ---------------------------------------------------------------

_path_append "$HOME/.local/bin"
_path_append "$HOME/.bun/bin"
_path_append "$HOME/.cargo/bin"
_path_append "$HOME/.cabal/bin"
_path_append "$HOME/.npm/modules/bin" # npm global prefix, see .npmrc

# PATH entries and variables of this machine's OS layers: after the common entries above, before
# the _has checks below, which may find tools only through these entries (Homebrew on macOS).
for _shell_layer in $_SHELL_OS_LAYERS; do
  if [[ -r "$_SHELL_DIR/os/$_shell_layer/env.sh" ]]; then
    . "$_SHELL_DIR/os/$_shell_layer/env.sh"
  fi
done

if _has go; then
  export GOPATH="$HOME/.go"
  _path_append "$GOPATH/bin"
fi

# --- Node (nvm) ---------------------------------------------------------
# Sourcing nvm.sh the usual way costs ~75 ms per shell: it resolves the default alias through
# dozens of subshells. Instead the default node goes on PATH in pure bash and nvm loads on first use.

export NVM_DIR="$HOME/.nvm"

# _nvm_use_default: put the installed node that $NVM_DIR/alias/default points to on PATH.
# Returns 1 when only nvm itself can resolve the alias (system, version not installed, ...).
function _nvm_use_default() {
  local want dir ver maj min pat bin="" best_maj=-1 best_min=-1 best_pat=-1 hops=0
  [[ -r "$NVM_DIR/alias/default" ]] || return 1
  read -r want < "$NVM_DIR/alias/default"
  [[ -n $want ]] || return 1
  # follow alias chains such as lts/* -> lts/krypton -> v24.22.1
  while [[ -f "$NVM_DIR/alias/$want" && $hops -lt 5 ]]; do
    read -r want < "$NVM_DIR/alias/$want"
    hops=$((hops + 1))
  done
  case $want in
    node | stable) want="" ;;
  esac
  want=${want#v}
  # highest installed version equal to $want or below it (24 -> 24.x.y); glob order is not numeric
  for dir in "$NVM_DIR/versions/node/v$want"*/bin; do
    ver=${dir%/bin}
    ver=${ver##*/v}
    [[ -x "$dir/node" && $ver =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || continue
    [[ -z $want || $ver == "$want" || $ver == "$want".* ]] || continue
    IFS=. read -r maj min pat <<< "$ver"
    if ((maj > best_maj || (maj == best_maj && (min > best_min || (min == best_min && pat > best_pat))))); then
      best_maj=$maj best_min=$min best_pat=$pat bin=$dir
    fi
  done
  [[ -n $bin ]] || return 1
  PATH="$bin:$PATH"
  export NVM_BIN="$bin"
  export NVM_INC="${bin%/bin}/include/node"
}

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # A node from nvm that is already on PATH (nested shell, earlier `nvm use`) stays active,
  # which is also what nvm.sh does.
  if [[ ":$PATH" == *":$NVM_DIR/versions/node/"* ]] || _nvm_use_default; then
    function nvm() {
      unset -f nvm
      . "$NVM_DIR/nvm.sh" --no-use
      if [[ $- == *i* && -s "$NVM_DIR/bash_completion" ]]; then
        . "$NVM_DIR/bash_completion"
      fi
      nvm "$@"
    }
    if [[ $- == *i* && -s "$NVM_DIR/bash_completion" ]]; then
      # First Tab on `nvm`: load nvm, then bash retries with nvm's own completion (status 124).
      function _nvm_lazy_complete() {
        nvm --version > /dev/null
        return 124
      }
      complete -F _nvm_lazy_complete nvm
    fi
  else
    . "$NVM_DIR/nvm.sh"
    if [[ $- == *i* && -s "$NVM_DIR/bash_completion" ]]; then
      . "$NVM_DIR/bash_completion"
    fi
  fi
fi

# --- exported variables -------------------------------------------------

export PATH
export HISTTIMEFORMAT="%y-%m-%d %T "
export no_proxy="localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,.local"
export NO_PROXY="$no_proxy"

if _has rclone; then
  export RCLONE_PROGRESS=1
  export RCLONE_MAX_DEPTH=1
  export RCLONE_HUMAN_READABLE=1
fi

if [[ -n "${JAVA_HOME:-}" ]] || _has java; then
  export SBT_OPTS="-Xmx2G -XX:MaxMetaspaceSize=768M"
fi

unset -f _path_append _path_prepend _nvm_use_default
