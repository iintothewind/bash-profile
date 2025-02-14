#! /usr/bin/env bash

function cf_lower() {
  echo "${1:-`cat`}" | tr '[:upper:]' '[:lower:]'
}

function cf_upper() {
  echo "${1:-`cat`}" | tr '[:lower:]' '[:upper:]'
}

function cf_starts_with() {
  local str=$1
  local pre=$2
  [[ "$str" ==  ${pre}* ]]
}

function cf_compose_url() {
  local inputUrl=$1
  local baseUrl=$2
  if test $inputUrl && (cf_starts_with $inputUrl $baseUrl || [[ $inputUrl =~ http.?://.+ ]]); then
    echo $inputUrl
  else
    echo "$baseUrl$inputUrl"
  fi
}

# used after a pipe, for example: echo '{ "k": "v"}' | cf_jsonfmt
function cf_json_format() {
  if type python > /dev/null 2>&1; then
    python -mjson.tool
  else
    echo "python is not found in PATH"
    return 1
  fi
}

function cf_json_escape() {
  if type python > /dev/null 2>&1; then
    python -c 'import sys, json; print(json.dumps(sys.stdin.read().strip()))'
  else
    echo "python is not found in PATH"
    return 1
  fi
}

# -u : user name, default value: $REQ_USER
# -p : password, default value: $REQ_PWD
# -l : request url, it can be full url (startsWith http://baseurl.com) or sub-path (/data/resource), default value: $REQ_BASE
# -m : request method, default value: $REQ_METHOD
# -d : request body, defaut read from stdin by cat
function cf_req() {
  local OPTIND=1
  local u;local p;local l;local m;local d;
  while getopts ":u:p:l:m:d:" o; do
      case "${o}" in
          u)  u=${OPTARG} ;;
          p)  p=${OPTARG} ;;
          l)  l=${OPTARG} ;;
          m)  m=${OPTARG} ;;
          d)  d=${OPTARG} ;;
      esac
  done
  if type curl > /dev/null 2>&1; then
    if (test $u || test $REQ_USER) && (test $p || test $REQ_PWD); then
      echo $(curl -k -s -u ${u:-$REQ_USER}:${p:-$REQ_PWD} -X `cf_upper ${m:-$REQ_METHOD}` -H "Accept: application/json" -H "Content-Type: application/json" $(cf_compose_url $l $REQ_BASE) -d @<(if test "GET" = `cf_upper ${m:-$REQ_METHOD}` || test "DELETE" = `cf_upper ${m:-$REQ_METHOD}`; then echo ""; else echo ${d:-`cat`}; fi))
    else
      echo $(curl -k -s -X `cf_upper ${m:-$REQ_METHOD}` -H "Accept: application/json" -H "Content-Type: application/json" $(cf_compose_url $l $REQ_BASE) -d @<(if test "GET" = `cf_upper ${m:-$REQ_METHOD}` || test "DELETE" = `cf_upper ${m:-$REQ_METHOD}`; then echo ""; else echo ${d:-`cat`}; fi))
    fi
  else
    echo "curl is not found in PATH"
    return 1
  fi
}

# cf_req -d '{ "query" : "MATCH (ee:Person) WHERE ee.name = \"Emil\" RETURN ee;", "params" : {} }'| cf_parse '["data"][0][0]["all_relationships"]'
# $1 the key
# $2 json string or read stdin from cat
function cf_parse() {
  if type python > /dev/null 2>&1; then
    python <<EOF
import json
try:
  print(json.loads('''${2:-`cat`}''')${1:-""})
except Exception as e:
  print("error: {}".format(e))
EOF
  else
    echo "python is not found in PATH"
    return 1
  fi
}


function cf_is_number() {
  [[ $1 =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]
}

function cf_is_integer() {
  [[ $1 =~ ^[+-]?[0-9]+$ ]]
}

function cf_trim() {
  echo "$@" | xargs
}

function cf_tail_args() {
  echo "$@" | xargs -n 1 | tail -n +2 | xargs
}

function cf_rand() {
  if cf_is_integer $1; then
    echo $((RANDOM%$1+1))
  else
    echo "input $1 is not an integer"
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
  if [[ $(uname) == Darwin ]]; then
    mount_point=${1}
    size=${2:-64}

    mkdir -p $mount_point
    if [ $? -ne 0 ]; then
        echo "The mount point didn't available." >&2
        return $?
    fi

    sector=$(expr $size \* 1024 \* 1024 / 512)
    device_name=$(hdid -nomount "ram://${sector}" | awk '{print $1}')
    if [ $? -ne 0 ]; then
        echo "Could not create disk image." >&2
        return $?
    fi

    newfs_hfs $device_name > /dev/null
    if [ $? -ne 0 ]; then
        echo "Could not format disk image." >&2
        return $?
    fi

    mount -t hfs $device_name $mount_point
    if [ $? -ne 0 ]; then
        echo "Could not mount disk image." >&2
        return $?
    fi
    return 0
  else
    echo "this function works on mac only" >&2
    return 1
  fi
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
  if [[ $(uname) == Darwin ]]; then
    mount_point=$1
    if [ ! -d "${mount_point}" ]; then
        echo "The mount point didn't available." >&2
        return 1
    fi
    mount_point=$(cd $mount_point && pwd)

    device_name=$(df "${mount_point}" 2>/dev/null | tail -1 | grep "${mount_point}" | cut -d' ' -f1)
    if [ -z "${device_name}" ]; then
        echo "The mount point didn't mount disk image." >&2
        return 1
    fi

    umount "${mount_point}"
    if [ $? -ne 0 ]; then
        echo "Could not unmount." >&2
        return $?
    fi

    hdiutil detach -quiet $device_name
    return $?
  else
    echo "this function works on mac only" >&2
    return 1
  fi
}

function cf_convert_to_opus()  {
  local path=$1
  local ext=$2
  if type ffmpeg > /dev/null 2>&1 && type parallel > /dev/null 2>&1; then
    if [[ -d $path && -n $ext ]]; then
      find $path -type f -iname "*.$ext" | sed -r "s/\.$ext//" | parallel -I% --max-args 1  \
        "ffmpeg -i %.$ext -strict -2 -c:a opus -b:a 64K -map_metadata 0 -compression_level 10 -y %.ogg > /dev/null 2>&1 && echo 'converted %.$ext to %.ogg'"
    else
      echo "path $path or extension $ext is invalid"
    fi
  else
    echo "ffmpeg or parallel is not installed"
  fi
}

function cf_convert_to_orbis()  {
  local path=$1
  local ext=$2
  if type ffmpeg > /dev/null 2>&1 && type parallel > /dev/null 2>&1; then
    if [[ -d $path && -n $ext ]]; then
      find $path -type f -iname "*.$ext" | sed -r "s/\.$ext//" | parallel -I% --max-args 1  \
        "ffmpeg -i %.$ext -strict -2 -c:a libvorbis -b:a 64K -map_metadata 0 -compression_level 10 -y %.ogg > /dev/null 2>&1 && echo 'converted %.$ext to %.ogg'"
    else
      echo "path $path or extension $ext is invalid"
    fi
  else
    echo "ffmpeg or parallel is not installed"
  fi
}

function cf_convert_to_m4a()  {
  local path=$1
  local ext=$2
  if type ffmpeg > /dev/null 2>&1 && type parallel > /dev/null 2>&1; then
    if [[ -d $path && -n $ext ]]; then
      find $path -type f -iname "*.$ext" | sed -r "s/\.$ext//" | parallel -I% --max-args 1  \
        "ffmpeg -i %.$ext -strict -2 -c:a aac -b:a 64K -map_metadata 0 -compression_level 10 -y %.m4a > /dev/null 2>&1 && echo 'converted %.$ext to %.m4a'"
    else
      echo "path $path or extension $ext is invalid"
    fi
  else
    echo "ffmpeg or parallel is not installed"
  fi
}

