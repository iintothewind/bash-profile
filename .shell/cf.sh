#! /usr/bin/env bash

# Prefer python3 when available
function cf_python_check() {
  if type python3 > /dev/null 2>&1; then
    python3 "$@"
  elif type python > /dev/null 2>&1; then
    python "$@"
  else
    echo "python is not found in PATH" >&2
    return 1
  fi
}

# $1 if set, otherwise stdin when not a tty
function cf_arg_or_stdin() {
  if [[ $# -ge 1 ]]; then
    printf '%s' "$1"
  elif [[ ! -t 0 ]]; then
    cat
  else
    return 1
  fi
}

function cf_lower() {
  local input
  input=$(cf_arg_or_stdin "$@") || {
    echo "usage: cf_lower [string]" >&2
    return 1
  }
  printf '%s\n' "$input" | tr '[:upper:]' '[:lower:]'
}

function cf_upper() {
  local input
  input=$(cf_arg_or_stdin "$@") || {
    echo "usage: cf_upper [string]" >&2
    return 1
  }
  printf '%s\n' "$input" | tr '[:lower:]' '[:upper:]'
}

function cf_starts_with() {
  local str=$1
  local pre=$2
  [[ "$str" == "$pre"* ]]
}

function cf_compose_url() {
  local inputUrl=$1
  local baseUrl=$2
  if [[ -n "$inputUrl" ]] && (cf_starts_with "$inputUrl" "$baseUrl" || [[ "$inputUrl" =~ http.?://.+ ]]); then
    printf '%s\n' "$inputUrl"
  else
    printf '%s\n' "${baseUrl}${inputUrl}"
  fi
}

# used after a pipe, for example: echo '{ "k": "v"}' | cf_json_format
function cf_json_format() {
  cf_python_check -m json.tool
}

function cf_json_escape() {
  cf_python_check -c 'import sys, json; print(json.dumps(sys.stdin.read().rstrip("\n")))'
}

# -u : user name, default value: $REQ_USER
# -p : password, default value: $REQ_PWD
# -l : request url, it can be full url (startsWith http://baseurl.com) or sub-path (/data/resource), default value: $REQ_BASE
# -t : authorization token
# -m : request method, default value: $REQ_METHOD
# -d : request body, default read from stdin when not a tty
# CF_REQ_INSECURE=0 to disable curl -k (default keeps -k for compatibility)
function cf_req() {
  local OPTIND=1
  local u p l t m d
  local has_d=0
  local method url body
  local -a curl_opts=()
  local -a auth_opts=()
  local -a data_opts=()

  while getopts ":u:p:l:t:m:d:" o; do
    case "${o}" in
      u) u=${OPTARG} ;;
      p) p=${OPTARG} ;;
      l) l=${OPTARG} ;;
      t) t=${OPTARG} ;;
      m) m=${OPTARG} ;;
      d) d=${OPTARG}; has_d=1 ;;
    esac
  done

  if ! type curl > /dev/null 2>&1; then
    echo "curl is not found in PATH" >&2
    return 1
  fi

  method=$(cf_upper "${m:-${REQ_METHOD:-GET}}")
  url=$(cf_compose_url "${l:-}" "${REQ_BASE:-}")

  curl_opts=(-s -S)
  if [[ "${CF_REQ_INSECURE:-1}" != "0" ]]; then
    curl_opts+=(-k)
  fi

  if [[ -n "${u:-${REQ_USER:-}}" && -n "${p:-${REQ_PWD:-}}" ]]; then
    auth_opts=(-u "${u:-$REQ_USER}:${p:-$REQ_PWD}")
  elif [[ -n "${t:-}" ]]; then
    auth_opts=(-H "Authorization: Bearer ${t}")
  fi

  if [[ "$method" != "GET" && "$method" != "DELETE" ]]; then
    if [[ "$has_d" -eq 1 ]]; then
      body=$d
    elif [[ ! -t 0 ]]; then
      body=$(cat)
    else
      body=""
    fi
    data_opts=(-d "$body")
  fi

  curl "${curl_opts[@]}" "${auth_opts[@]}" \
    -X "$method" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    "${data_opts[@]}" \
    -- "$url"
}

# cf_req -d '{...}' | cf_parse '["data"][0][0]["all_relationships"]'
# $1 path like ["data"][0]["key"]
# $2 json string, or read stdin when not a tty
function cf_parse() {
  local path="${1:-}"
  local json

  if [[ $# -ge 2 ]]; then
    json=$2
  elif [[ ! -t 0 ]]; then
    json=$(cat)
  else
    echo "usage: cf_parse <path> [json]" >&2
    return 1
  fi

  printf '%s' "$json" | CF_PARSE_PATH="$path" cf_python_check -c 'import json,re,sys,os
path=os.environ["CF_PARSE_PATH"]
try:
    obj=json.loads(sys.stdin.read())
    for m in re.finditer(r"\[\"([^\"]*)\"\]|\[(\d+)\]", path):
        obj=obj[m.group(1)] if m.group(1) is not None else obj[int(m.group(2))]
    print(json.dumps(obj, ensure_ascii=False) if isinstance(obj,(dict,list)) else obj)
except Exception as e:
    print("error: {}".format(e))
    sys.exit(1)
'
}

function cf_is_number() {
  [[ "$1" =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]
}

function cf_is_integer() {
  [[ "$1" =~ ^[+-]?[0-9]+$ ]]
}

function cf_trim() {
  local s="$*"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s\n' "$s"
}

function cf_tail_args() {
  shift
  printf '%s\n' "$*"
}

function cf_rand() {
  if cf_is_integer "$1"; then
    echo $((RANDOM % $1 + 1))
  else
    echo "input $1 is not an integer" >&2
    return 1
  fi
}

# Usage:
#   $0 <dir> <size>
#
#   size:
#     The `size' is a size of disk image (MB).
#
#   dir:
#     The `dir' is a directory, the dir is used to mount the disk image.
#
# See also:
#   - hdid(8)
#
function cf_mount_ram() {
  if [[ $(uname) != Darwin ]]; then
    echo "this function works on mac only" >&2
    return 1
  fi

  local mount_point=$1
  local size=${2:-64}
  local sector device_name

  if ! mkdir -p "$mount_point"; then
    echo "The mount point didn't available." >&2
    return 1
  fi

  sector=$((size * 1024 * 1024 / 512))
  device_name=$(hdid -nomount "ram://${sector}" | awk '{print $1}')
  if [[ -z "$device_name" ]]; then
    echo "Could not create disk image." >&2
    return 1
  fi

  if ! newfs_hfs "$device_name" > /dev/null; then
    echo "Could not format disk image." >&2
    return 1
  fi

  if ! mount -t hfs "$device_name" "$mount_point"; then
    echo "Could not mount disk image." >&2
    return 1
  fi
  return 0
}

# Usage:
#   $0 <dir>
#
#   dir:
#     The `dir' is a directory, the dir is mounting a disk image.
#
# See also:
#   - hdid(8)
#
function cf_unmount_ram() {
  if [[ $(uname) != Darwin ]]; then
    echo "this function works on mac only" >&2
    return 1
  fi

  local mount_point=$1
  local device_name

  if [[ ! -d "$mount_point" ]]; then
    echo "The mount point didn't available." >&2
    return 1
  fi
  mount_point=$(cd "$mount_point" && pwd)

  device_name=$(df "$mount_point" 2>/dev/null | tail -1 | grep "$mount_point" | awk '{print $1}')
  if [[ -z "$device_name" ]]; then
    echo "The mount point didn't mount disk image." >&2
    return 1
  fi

  if ! umount "$mount_point"; then
    echo "Could not unmount." >&2
    return 1
  fi

  hdiutil detach -quiet "$device_name"
}

# cf_convert_audio <codec> <out_ext> <path> <in_ext>
function cf_convert_audio() {
  local codec=$1
  local out_ext=$2
  local path=$3
  local ext=$4

  if ! type ffmpeg > /dev/null 2>&1 || ! type parallel > /dev/null 2>&1; then
    echo "ffmpeg or parallel is not installed" >&2
    return 1
  fi

  if [[ ! -d "$path" || -z "$ext" ]]; then
    echo "path $path or extension $ext is invalid" >&2
    return 1
  fi

  find "$path" -type f -iname "*.$ext" | parallel -I% --max-args 1 \
    "ffmpeg -i % -strict -2 -c:a $codec -b:a 64K -map_metadata 0 -compression_level 10 -y {.}.$out_ext > /dev/null 2>&1 && echo 'converted % to {.}.$out_ext'"
}

function cf_convert_to_opus() {
  cf_convert_audio opus ogg "$1" "$2"
}

function cf_convert_to_vorbis() {
  cf_convert_audio libvorbis ogg "$1" "$2"
}

# typo-compatible alias
function cf_convert_to_orbis() {
  cf_convert_to_vorbis "$@"
}

function cf_convert_to_m4a() {
  cf_convert_audio aac m4a "$1" "$2"
}
