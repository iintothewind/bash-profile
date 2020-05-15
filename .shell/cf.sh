#! /usr/bin/env bash

function cf_is_number() {
  [[ $1 =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]
}

function cf_is_integer() {
  [[ $1 =~ ^[+-]?[0-9]+$ ]]
}

function cf_trim() {
  echo "$@" | xargs
}

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
