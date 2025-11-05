#!/bin/bash

sketchybar --add item gitlab right \
           --set gitlab update_freq=30 \
           script="$PLUGIN_DIR/gitlab.sh" \

