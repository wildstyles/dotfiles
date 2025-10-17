#!/bin/bash

ICON="􀐱"

sketchybar --add item timewarrior left \
           --set timewarrior      background.color=$YELLOW \
                                  update_freq=1 \
                                  icon.color=$BAR_COLOR \
                                  icon.font="sketchybar-app-font:Regular:16.0" \
                                  icon="$ICON" \
                                  label.color=$BAR_COLOR \
                                  drawing=off \
                                  script="$PLUGIN_DIR/timewarrior.sh"
