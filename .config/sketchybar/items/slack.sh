#!/bin/bash

sketchybar  --add   item slack right \
            --set   slack \
                    update_freq=5 \
                    script="$PLUGIN_DIR/slack.sh" \
                    icon.font="sketchybar-app-font:Regular:16.0" \
           --subscribe slack system_woke
