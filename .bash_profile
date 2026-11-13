#!/usr/bin/env bash
# The whole shell setup lives in ~/.shell; init.sh is its single entry point.
# This file comes from the bash-profile repo: change it there and run sync_cfg.
if [[ -r "$HOME/.shell/init.sh" ]]; then
  . "$HOME/.shell/init.sh"
fi
