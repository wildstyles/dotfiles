#!/bin/bash

sketchybar --add item gitlab_build right \
           --set gitlab_build update_freq=30 \
           script="$PLUGIN_DIR/gitlab.sh" \


sketchybar --add item gitlab_assigned right \
           --set gitlab_assigned  \

