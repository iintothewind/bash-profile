#!/usr/bin/env bash
# os/termux/alias.sh: aliases that exist on Termux (Android) only.
# Loaded by init.sh in interactive shells when /data/data/com.termux exists, as the last layer:
# after alias.sh and after every other os/<layer>/alias.sh. Same contract as alias.sh.
# No OS check in here: being in this directory is the check.

alias sshdup='termux-wake-lock && sshd'
