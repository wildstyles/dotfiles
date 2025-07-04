#!/usr/bin/env bash

CONFIG_NAME="ruslan_02_24"
  
# AUTH, CONNECTED, EXITING
STATUS=$(osascript -e "tell application \"Tunnelblick\" to get state of configurations")

echo "Tunnelblick profile $CONFIG_NAME is: $STATUS"

if [[ $STATUS == "CONNECTED" ]]; then
osascript \
  -e "tell application \"Tunnelblick\"" \
  -e "disconnect \"$CONFIG_NAME\"" \
  -e "end tell"
elif [[ $STATUS == "EXITING" ]]; then
osascript \
  -e "tell application \"Tunnelblick\"" \
  -e "connect \"$CONFIG_NAME\"" \
  -e "end tell"
fi
