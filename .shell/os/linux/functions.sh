#!/usr/bin/env bash
# os/linux/functions.sh: command functions that exist on Linux only, whatever the distribution.
# Loaded by init.sh in every shell when $OSTYPE is linux*, after functions.sh and before the
# distribution layers; same contract as functions.sh.
# No OS check in here: being in this directory is the check.

# rmrtlan: delete the default route of an interface (asks which one; disconnects the network)
function rmrtlan() {
  local iface
  echo "WARNING: This will delete the default route and disconnect the network!"
  read -p "Enter the interface to drop (e.g. eth0, enp0s31f6): " iface
  if [[ -z "$iface" ]]; then
    echo "no interface given, aborting" >&2
    return 1
  fi
  sudo ip route del default dev "$iface"
}
