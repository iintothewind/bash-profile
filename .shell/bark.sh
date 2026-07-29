#! /usr/bin/env bash

if [[ -f $HOME/.shell/cf.sh ]]; then

  # usage: cf_bark <device_key> [message]
  # message from $2, or stdin when not a tty; otherwise print usage
  function cf_bark() {
    local key="${1:?device key required}"
    local msg

    if [[ $# -ge 2 ]]; then
      msg="$2"
    elif [[ ! -t 0 ]]; then
      msg=$(cat)
    else
      echo "usage: cf_bark <device_key> [message]" >&2
      return 1
    fi

    local url="https://api.day.app/${key}"
    local body
    body=$(printf '%s' "$msg" | cf_json_escape)
    printf '%s' "{\"level\":\"active\",\"action\":\"none\",\"badge\":1,\"isArchive\":1,\"group\":\"default\",\"title\":\"bark message\",\"body\":${body}}" \
      | cf_req -l "$url" -m post
  }

  function cf_bark_ivar() {
    cf_bark "4CS4ncYoRbEkdbtsecagFT" "$@"
  }

  function cf_bark_ashley() {
    cf_bark "VzhjJbmaBZzz6T6bBoMD73" "$@"
  }

fi
