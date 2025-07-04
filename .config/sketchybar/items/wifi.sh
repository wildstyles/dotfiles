#!/bin/bash

sketchybar --add item wifi right           \
           --set wifi                      \
           script="$PLUGIN_DIR/wifi.sh"    \
           label.padding_left=0            \
           update_freq=5
