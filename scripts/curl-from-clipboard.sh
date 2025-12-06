#!/bin/bash

# Initialize flags
replace_urls=false
strip_headers=false

# Parse arguments
while getopts "rh" opt; do
  case $opt in
    r)
      replace_urls=true
      ;;
    h)
      strip_headers=true
      ;;
    *)
      echo "Usage: $0 [-r] [-h]"
      exit 1
      ;;
  esac
done

# Get the curl command from the clipboard
original_curl=$(pbpaste)
modified_curl=$(echo "$original_curl")

if $replace_urls; then
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-scott.api.scoutgg-stg.net|http://localhost:3040|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-scott.api.scoutgg-stg.net|http://localhost:3040|g')

  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-wallet.api.scoutgg-stg.net|http://localhost:3020|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-wallet.api.scoutgg-stg.net|http://localhost:3020|g')

  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-game.api.scoutgg-stg.net|http://localhost:3090|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-game.api.scoutgg-stg.net|http://localhost:3090|g')
fi

echo -e "$modified_curl" | pbcopy

/Users/ruslanvanzula/Projects/dotfiles/scripts/kitty-switch-session.sh http

sock=$(ls /tmp/kitty-* 2>/dev/null | head -n1)

# Check if we found a socket, otherwise exit
if [[ -z "$sock" ]]; then
    echo "No Kitty instance found."
    exit 1
fi

/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key ctrl+q

sleep 0.5

/Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:${sock}" send-text n mini-leagues.http 
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key enter

sleep 0.2

if $strip_headers; then
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key ,
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key k
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key p
else
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key ,
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key k
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key c
fi
