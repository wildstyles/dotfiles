#!/bin/bash


sketchybar --add item kitty center \
           --set kitty script="$PLUGIN_DIR/kitty.sh" \
           --add event kitty_event \
           --subscribe kitty kitty_event \

