#!/bin/bash


sketchybar --add item tmux center \
           --set tmux script="$PLUGIN_DIR/tmux.sh" \
           --add event tmux_event \
           --subscribe tmux tmux_event \



