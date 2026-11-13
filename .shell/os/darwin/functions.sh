#!/usr/bin/env bash
# os/darwin/functions.sh: command functions that exist on macOS only.
# Loaded by init.sh in every shell when $OSTYPE is darwin*, after functions.sh; same contract as functions.sh.
# No OS check in here: being in this directory is the check.

# setdns <server>...: set the DNS servers of every network service
function setdns() {
  local network_service
  networksetup -listallnetworkservices | tail -n +2 | while IFS= read -r network_service; do
    sudo networksetup -setdnsservers "$network_service" "$@"
  done
}

# unsetdns: back to the DNS servers handed out by DHCP
function unsetdns() {
  setdns Empty
}
