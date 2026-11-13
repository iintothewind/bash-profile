#!/usr/bin/env bash
# functions.sh: short-named command functions for everyday use.
# Loaded by init.sh in every shell, interactive or not.
# Contract:
#   - definitions only: nothing runs at load time; tools are checked with _has when a function is called
#   - stdout carries results only; usage and validation errors go to stderr with return 1
#   - never name a function after an existing command
#   - call `command rm`, not `rm`: alias.sh aliases rm and a re-source would bake the alias in
#   - a function for one OS or one Linux distribution only goes to os/<layer>/functions.sh, not here

# --- search ---------------------------------------------------------------

# qf <name-pattern>: find below the current directory, case-insensitive
function qf() { find . -iname "$1" -print; }

# qenv / qhs / qals <text>: fixed-string search in environment, history, aliases
function qenv() { env | grep -F "$@"; }
function qhs() { history | grep -F "$@"; }
function qals() { alias | grep -F "$@"; }

# qps <pattern>: processes matching <pattern> (regex), busiest first where ps can sort
function qps() {
  if [[ $OSTYPE == linux* ]]; then
    ps ax -mwww -o pid,ppid,user,pcpu,pmem,args --sort -pcpu,-pmem
  else
    ps ax -mwww -o pid,ppid,user,pcpu,pmem,args
  fi | grep -v grep | grep --color=auto "$@"
}

# lsf [grep-args]: open network sockets with their owners (sudo)
function lsf() {
  if [[ $# -eq 0 ]]; then
    set -- ''
  fi
  sudo lsof -i -n -P | awk '{print $1,$2,$3,$5,$8,$9}' | grep "$@"
}

# rgs <text>: ripgrep file types matching <text>
function rgs() {
  if ! _has rg; then
    echo "rg does not exist" >&2
    return 1
  fi
  if [[ $# -eq 0 ]]; then
    echo "please give a file extension to search the support type" >&2
    echo "then use: rg [-t support-type] pattern [path]" >&2
    return 1
  fi
  rg --type-list | grep "$@"
}

# --- archives -------------------------------------------------------------

# tgza <src-dir> <dest.tgz|dest.tar.gz>: pack the contents of <src-dir>
function tgza() {
  local path=$1
  local file=$2
  if [[ $# -lt 2 ]]; then
    echo "tgza <src-path> <dest-file>" >&2
    echo "alias for: tar cvzf <dest-file.tgz> -C <src-path> ." >&2
    echo "dest-file is required to be ended with .tgz or .tar.gz" >&2
    return 1
  fi
  if [[ ! -d "$path" ]]; then
    echo "src-path must be existing: $path" >&2
    return 1
  fi
  case "$file" in
    *.tgz | *.tar.gz) ;;
    *)
      echo "dest-file must end with .tgz or .tar.gz: $file" >&2
      return 1
      ;;
  esac
  echo "tar cvzf $file -C $path ."
  tar cvzf "$file" -C "$path" .
}

# tgzx <src.tgz> <dest-dir> [members...]: unpack into <dest-dir> (created when missing)
function tgzx() {
  if [[ $# -lt 2 ]]; then
    echo "tgzx <src-file> <dest-path> [extract-files]" >&2
    echo "alias for: tar xvzf <src-file> -C <dest-path> [extract-files]" >&2
    echo "list files in tgz: tar vtf <src-file>" >&2
    return 1
  fi
  if [[ ! -f "$1" ]]; then
    echo "src-file must be existing: $1" >&2
    return 1
  fi
  case "$1" in
    *.tgz | *.tar.gz | *.gz) ;;
    *)
      echo "src-file must end with .tgz, .tar.gz, or .gz: $1" >&2
      return 1
      ;;
  esac

  local tgzFile=$1
  local destPath=$2
  shift 2
  echo "tar xvzf $tgzFile -C $destPath $*"

  mkdir -p "$destPath"
  tar xvzf "$tgzFile" -C "$destPath" "$@"
}

# --- date and math --------------------------------------------------------

# GNU date (Linux, or macOS with coreutils gnubin on PATH) and BSD date take different flags.
function _date_is_gnu() {
  date --version > /dev/null 2>&1
}

# epoch_date <epoch>: epoch seconds (digits after the 10th are ignored) to local date
function epoch_date() {
  local input="$*"
  if [[ ! $input =~ ^[0-9]{10,}$ ]]; then
    echo "invalid epoch format, current epoch: $(date +%s) date: $(date "+%Y-%m-%d %H:%M:%S")" >&2
    return 1
  fi
  local epoch="${input:0:10}"
  if _date_is_gnu; then
    date -d "@$epoch" "+%Y-%m-%d %H:%M:%S"
  else
    date -r "$epoch" "+%Y-%m-%d %H:%M:%S"
  fi
}

# date_epoch <YYYY-MM-DD?HH:MM:SS>: local date to epoch seconds
function date_epoch() {
  local input="$*"
  if [[ ! $input =~ ^[1-9][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]).+(20|21|22|23|[0-1][0-9]):[0-5][0-9]:[0-5][0-9]$ ]]; then
    echo "invalid date format, current date: $(date "+%Y-%m-%d %H:%M:%S") epoch: $(date +%s)" >&2
    return 1
  fi
  if _date_is_gnu; then
    date -d "$input" "+%s"
  else
    # BSD date wants the exact format: leading date and trailing time, whatever sits between
    date -j -f "%Y-%m-%d %H:%M:%S" "${input:0:10} ${input: -8}" "+%s"
  fi
}

# bcal <expr>, or <expr> on stdin: evaluate with bc, 3 decimals
function bcal() {
  if ! _has bc; then
    echo "bc does not exist" >&2
    return 1
  fi
  printf '%.3f\n' "$(echo "scale=3; ${*:-$(cat)}" | bc)"
}

# --- files ----------------------------------------------------------------

# ffmax <+N|-N><M|G> [dir]: files above (+) or below (-) the size, biggest first
function ffmax() {
  local size_arg="$1"
  local dir="${2:-.}"
  if [[ ! $size_arg =~ ^[-+][0-9]+[MG]$ || ! -d "$dir" ]]; then
    echo "wrong size format, should be e.g +2M,-6G, or input directory not existing" >&2
    return 1
  fi
  find "$dir" -type f -size "$size_arg" -exec ls -lhS {} +
}

# catdup <file>: duplicated lines of a text file with their counts
function catdup() {
  if [[ ! -f "$1" ]] || ! file -b "$1" | grep -qi 'text'; then
    echo "input file does not exist or not a text file" >&2
    return 1
  fi
  sort "$1" | uniq -dc
}

# md <dir>: create <dir> and cd into it
function md() {
  if [[ -z "$1" ]]; then
    echo "enter a name for this folder" >&2
    return 1
  fi
  if [[ -d "$1" ]]; then
    echo "$1 already exists" >&2
    return 1
  fi
  mkdir -p "$1" && cd "$1" && pwd
}

# bu <file>: copy <file> to <file>.<timestamp>.backup
function bu() {
  if [[ ! -f "$1" ]]; then
    echo "$1 does not exist" >&2
    return 1
  fi
  cp "$1" "$1.$(date +%Y%m%d%H%M%S).backup"
}

# chext <dir> <old-ext> <new-ext>: rename *.<old-ext> below <dir>; extensions without the dot
function chext() {
  local path=$1
  local oldExt=$2
  local newExt=$3
  if [[ ! -d "$path" || -z "$oldExt" || -z "$newExt" ]]; then
    echo "chext path oldExt newExt" >&2
    echo "args: path oldExt newExt are required, extension name should not include dot (.) character" >&2
    return 1
  fi
  find "$path" -type f -name "*.$oldExt" -exec sh -c 'mv "$0" "${0%.$1}.$2"' {} "$oldExt" "$newExt" \;
}

# renamex <dir> <find-name-pattern> <sed-E-script>: rename matching files with a sed expression
function renamex() {
  local path=$1
  local searchPattern=$2
  local replaceRegex=$3
  if [[ ! -d "$path" || -z "$searchPattern" || -z "$replaceRegex" ]]; then
    echo "renamex path searchPattern replaceRegex" >&2
    echo "args: path searchPattern replaceRegex are required" >&2
    echo "searchPattern is a name pattern for find" >&2
    echo "replaceRegex is an replace regex for sed" >&2
    echo "example: extract number in the middle: \"s/([a-z A-Z \s]+)([0-9]+)(.+)/snapshot_\2.png/\"" >&2
    echo "example: remove chinese characters in the middle: \"s/([0-9]+)([^\x00-\xff]+)(\.[0-9 a-z]+)/\1\3/\"" >&2
    return 1
  fi
  local file newFile
  find "$path" -type f -name "$searchPattern" -print0 | while IFS= read -r -d '' file; do
    newFile=$(echo "$file" | sed -E "$replaceRegex")
    if [[ "$file" != "$newFile" ]]; then
      mv -n "$file" "$newFile"
      echo "Renamed $file to $newFile"
    fi
  done
}

# --- network --------------------------------------------------------------

# fips: local IPv4 addresses, comma separated
function fips() {
  local list=""
  if _has ip; then
    list=$(ip -o -4 addr list | awk '{print $4}' | cut -d'/' -f1 | tr '\n' ',')
  elif _has ifconfig; then
    list=$(ifconfig | grep "inet " | awk '{print $2}' | sed 's/addr://' | tr '\n' ',')
  fi
  echo "${list%,}"
}

# sshkeygen: replace every ~/.ssh/id_* key with a fresh RSA pair, after confirmation
function sshkeygen() {
  echo "WARNING: This will remove ALL existing SSH keys in ~/.ssh and generate new ones."
  read -p "Are you sure? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    command rm -f "$HOME"/.ssh/id_* && ssh-keygen -q -t rsa -N '' -f "$HOME/.ssh/id_rsa"
  fi
}

# --- JVM ------------------------------------------------------------------

# mvn_skiptest [mvn-args]: mvn without compiling or running tests
function mvn_skiptest() {
  if ! _has mvn; then
    echo "mvn does not exist" >&2
    return 1
  fi
  mvn -Dmaven.test.skip=true "$@"
}

# qjps <text>: running JVMs whose jps -v line contains <text>
function qjps() {
  if ! _has jps; then
    echo "jps does not exist" >&2
    return 1
  fi
  jps -v | grep -F "$@"
}

# _jar_list <jar>: entry names. unzip skips the JVM start that `jar -tf` pays per file.
function _jar_list() {
  if _has unzip; then
    unzip -Z1 "$1"
  else
    jar -tf "$1"
  fi
}

# lsjar <file.jar>: list the entries of a jar
function lsjar() {
  if [[ ! -f "$1" || "$1" != *.jar ]] || ! { _has unzip || _has jar; }; then
    echo "unzip/jar does not exist, or not an existing jar file" >&2
    return 1
  fi
  _jar_list "$1"
}

# findInJar <dir> <text>: entries containing <text> in every jar below <dir>
function findInJar() {
  local path=$1
  local file=$2
  if [[ ! -d "$path" || -z "$file" ]] || ! { _has unzip || _has jar; }; then
    echo "findInJar <path> <filename-pattern>" >&2
    echo "unzip or jar must exist; path must be a directory; filename pattern is required" >&2
    return 1
  fi
  local jarFile
  find "$path" -type f -iname "*.jar" -print0 | while IFS= read -r -d '' jarFile; do
    _jar_list "$jarFile" | JAR="$jarFile" PART="$file" awk 'index($0, ENVIRON["PART"]) { print ENVIRON["JAR"] " : " $0 }'
  done
}

# _cacerts_path: the JDK truststore; JDK 9+ dropped the jre/ directory of JDK 8
function _cacerts_path() {
  local c
  for c in "$JAVA_HOME/lib/security/cacerts" "$JAVA_HOME/jre/lib/security/cacerts"; do
    if [[ -f "$c" ]]; then
      printf '%s\n' "$c"
      return 0
    fi
  done
  printf '%s\n' "$JAVA_HOME/lib/security/cacerts"
}

# list_cert [keystore] [storepass]: list a keystore, by default the JDK truststore
function list_cert() {
  if ! _has keytool; then
    echo "keytool does not exist" >&2
    return 1
  fi
  local keystore=${1:-$(_cacerts_path)}
  local storepass=${2:-changeit}
  keytool -list -keystore "$keystore" -storepass "$storepass"
}

# import_cert <file> <alias> [keypass] [keystore] [storepass]: import a certificate
function import_cert() {
  if ! _has keytool; then
    echo "keytool does not exist" >&2
    return 1
  fi
  local file=$1
  local cert_alias=$2
  local keypass=$3
  local keystore=${4:-$(_cacerts_path)}
  local storepass=${5:-changeit}
  local -a keypass_opts=()
  if [[ -n "$keypass" ]]; then
    keypass_opts=(-keypass "$keypass")
  fi
  keytool -importcert -keystore "$keystore" -storepass "$storepass" -file "$file" -alias "$cert_alias" "${keypass_opts[@]}"
}
