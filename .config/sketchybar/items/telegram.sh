#!/bin/bash

sketchybar  --add   item telegram right \
            --set   telegram \
                    update_freq=5 \
                    script="$PLUGIN_DIR/telegram.sh" \
                    icon.font="sketchybar-app-font:Regular:16.0" \
                    # icon.font.size=18 \
           --subscribe telegram system_woke

