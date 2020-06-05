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
}
