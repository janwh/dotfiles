#!/usr/bin/env bash
set -euo pipefail

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if [ -t 1 ]; then
  RED=$(printf '\033[31m')
  BLUE=$(printf '\033[34m')
  RESET=$(printf '\033[m')
else
  RED=""
  BLUE=""
  RESET=""
fi

cd "$DOTFILES"

# Set git config values
# Line endings
git config core.eol lf
git config core.autocrlf false
# Autostash on rebase
resetAutoStash=$(git config --bool rebase.autoStash 2>&1)
git config rebase.autoStash true


printf "${BLUE}%s${RESET}\n" "Updating Dotfiles"
if git pull --rebase --stat origin master
then
  status=0

  printf '%s    _                        %s __ %s  _       _    __ _ _               %s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf '%s   (_)                      %s / /%s  | |     | |  / _(_) |              %s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf '%s    _  __ _ _ ____      __ %s / /%s __| | ___ | |_| |_ _| | ___  ___     %s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf '%s   | |/ _` | '"'"'_ \ \ /\ / /%s / /%s / _` |/ _ \| __|  _| | |/ _ \/ __|%s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf '%s   | | (_| | | | \ V  V /%s / /%s | (_| | (_) | |_| | | | |  __/\__ \    %s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf '%s   | |\__,_|_| |_|\_/\_/%s /_/%s   \__,_|\___/ \__|_| |_|_|\___||___/    %s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf '%s  _/ |                  %s    %s                                         %s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf '%s |__/                   %s    %s                                         %s\n' "$BLUE" "$RED" "$BLUE" "$RESET"
  printf "\n${BLUE}%s${RESET}\n\n" 'Hooray! Dotfiles have been updated and/or are at the current version.'
else
  status=$?
  printf "\n${RED}%s${RESET}\n\n" 'There was an error updating. Try again later?'
fi

# Unset git-config values set just for the upgrade
case "$resetAutoStash" in
  "") git config --unset rebase.autoStash ;;
  *) git config rebase.autoStash "$resetAutoStash" ;;
esac

# Exit with `1` if the update failed
exit $status
