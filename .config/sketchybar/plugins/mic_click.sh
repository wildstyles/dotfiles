#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh" # Loads all defined colors

MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)')

if [[ $MIC_VOLUME -lt 100 ]]; then
  osascript -e 'set volume input volume 100'
  /opt/homebrew/bin/sketchybar -m --set mic icon.color=$WHITE icon="􀊱" 
elif [[ $MIC_VOLUME -gt 0 ]]; then
  osascript -e 'set volume input volume 0'
  /opt/homebrew/bin/sketchybar -m --set mic icon.color=$RED icon="􀊳" 
fi
