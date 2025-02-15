#! /usr/bin/env bash

if [[ -f $HOME/.shell/cf.sh ]]; then

  function cf_bark_ivar() {
    local url="https://api.day.app/4CS4ncYoRbEkdbtsecagFT"
    local msgPrefix='{"level":"active","action":"none","badge":1,"isArchive":1,"group":"test","title":"bark message","body":'
    local msgContent=$(echo "${1:-`cat`}" | cf_json_escape)
    local msgSuffix='}'

    echo "${msgPrefix}${msgContent}${msgSuffix}" | cf_req -l $url -m post 
  }

  function cf_bark_ashley() {
    local url="https://api.day.app/VzhjJbmaBZzz6T6bBoMD73"
    local msgPrefix='{"level":"active","action":"none","badge":1,"isArchive":1,"group":"test","title":"bark message","body":'
    local msgContent=$(echo "${1:-`cat`}" | cf_json_escape)
    local msgSuffix='}'

    echo "${msgPrefix}${msgContent}${msgSuffix}" | cf_req -l $url -m post 
  }

fi

