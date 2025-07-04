#!/bin/bash

keyboard=(
    icon.font="sketchybar-app-font:Regular:16.0" \
    label.padding_left=0            \
    script="$PLUGIN_DIR/keyboard.sh"
)

sketchybar --add item keyboard right        \
           --set keyboard "${keyboard[@]}"  \
           --add event keyboard_change "AppleSelectedInputSourcesChangedNotification" \
           --subscribe keyboard keyboard_change
