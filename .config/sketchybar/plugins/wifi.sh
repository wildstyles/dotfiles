#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

CONFIG_NAME="ruslan_02_24"
CURRENT_WIFI="$(ipconfig getsummary "$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')" | grep '  SSID : ' | awk -F ': ' '{print $2}')"

VPN_STATUS=$(osascript -e "tell application \"Tunnelblick\" to get state of configurations")

if [ "$CURRENT_WIFI" = "" ]; then
   ICON=􀙈
else
   ICON=􀙇
fi


# AUTH, CONNECTED, EXITING
if [[ $VPN_STATUS == "CONNECTED" ]]; then
  ICON_COLOR=$GREEN
elif [[ $VPN_STATUS == "EXITING" ]]; then
  ICON_COLOR=$WHITE
else
  ICON_COLOR=$YELLOW
fi

sketchybar --set $NAME icon="$ICON" icon.color="$ICON_COLOR"

