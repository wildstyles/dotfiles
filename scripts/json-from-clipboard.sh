#!/bin/bash


/Users/ruslanvanzula/Projects/dotfiles/scripts/kitty-switch-session.sh json 

sock=$(ls /tmp/kitty-* 2>/dev/null | head -n1)

# Check if we found a socket, otherwise exit
if [[ -z "$sock" ]]; then
    echo "No Kitty instance found."
    exit 1
fi

/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" focus-window --match 'title:json'

/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key ctrl+q

sleep 0.1

/Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:${sock}" send-text rm -rf example.json
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key enter
sleep 0.1
/Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:${sock}" send-text touch example.json
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key enter

sleep 0.1

/Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:${sock}" send-text n example.json
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key enter

# sleep 0.2
#
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key p
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key ctrl+s
