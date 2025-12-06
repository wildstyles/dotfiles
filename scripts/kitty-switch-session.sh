#!/usr/bin/env bash

set -euo pipefail

# Assign default values if not provided
# session="$1"
session="${1:-}"
tab="${2:-}"

# Locate the first available Kitty socket
sock=$(ls /tmp/kitty-* 2>/dev/null | head -n1)

# Check if we found a socket, otherwise exit
if [[ -z "$sock" ]]; then
    echo "No Kitty instance found."
    exit 1
fi

/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action goto_session "$session"

if [[ -n "$tab" ]]; then
    /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" focus-tab --match title:"$tab"
fi

