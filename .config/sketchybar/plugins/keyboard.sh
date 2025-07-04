#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"


case "$LAYOUT" in
  "\"Colemak DH Matrix\"" )
    ICON="􀺑"
    COLOR=$YELLOW
    ;;
  "ABC" )
    ICON="􀺑"
    COLOR=$WHITE
    ;;
  * )
    ICON="􀇳"
    COLOR=$WHITE
    ;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"

