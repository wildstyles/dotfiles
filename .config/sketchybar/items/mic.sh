#!/bin/bash

sketchybar -m --add item mic right \
              --set mic script="~/.config/sketchybar/plugins/mic.sh" \
              --set mic click_script="~/.config/sketchybar/plugins/mic_click.sh" \
            --set mic update_freq=3 \
              label.padding_left=0            \
              --subscribe mic volume_change 

