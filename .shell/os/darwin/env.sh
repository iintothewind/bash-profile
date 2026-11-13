#!/usr/bin/env bash
# os/darwin/env.sh: PATH entries and exported variables that exist on macOS only.
# Loaded by env.sh in every shell when $OSTYPE is darwin*, at the end of its PATH section:
# _path_append/_path_prepend are available, and env.sh's _has checks come after this file.
# Same contract as env.sh. The one fork is /usr/libexec/java_home, only while JAVA_HOME is not inherited.
# No OS check in here: being in this directory is the check.

# Homebrew prefix without running brew: /opt/homebrew on Apple Silicon, /usr/local on Intel.
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    HOMEBREW_PREFIX=/opt/homebrew
  elif [[ -x /usr/local/bin/brew ]]; then
    HOMEBREW_PREFIX=/usr/local
  fi
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  _path_prepend "$HOMEBREW_PREFIX/bin"
  _path_append "$HOMEBREW_PREFIX/sbin"
  # GNU coreutils under their real names (ls, date, ...) plus their man pages
  _path_prepend "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  _gnuman="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman"
  if [[ -d "$_gnuman" && ":${MANPATH:-}:" != *":$_gnuman:"* ]]; then
    export MANPATH="$_gnuman:${MANPATH:-}"
  fi
  unset _gnuman
fi

export HOMEBREW_NO_AUTO_UPDATE=1

if [[ -z "${JAVA_HOME:-}" && -x /usr/libexec/java_home ]]; then
  _java_home=$(/usr/libexec/java_home 2> /dev/null)
  if [[ -n "$_java_home" ]]; then
    export JAVA_HOME="$_java_home"
  fi
  unset _java_home
fi
