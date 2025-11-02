#!/bin/bash


source "$CONFIG_DIR/colors.sh" # Loads all defined colors

sketchybar --remove '/tmux.window.*/'

current_session=$(tmux display-message -p '#S')
WINDOWS=$(tmux list-windows -F "#{window_index}:#{window_name}:#{?window_active,active,inactive}" | sort -t':' -n -k1)

while IFS=: read -r index name status; do
    echo "$index"

    label_color=$WHITE
    background_color=$ITEM_BG_COLOR

    if [ "$status" = "active" ]; then
        label_color=$BAR_COLOR
        background_color=$YELLOW
    fi

    sketchybar --add item tmux.window."$index" left \
        --set tmux.window."$index" \
        drawing=off \
        label="$name" icon="$index" \
        icon.padding_left=8 \
        label.color="$label_color" \
        icon.color="$label_color" \
        background.color="$background_color" \
        label.padding_right=10
done <<< "$WINDOWS"

if [ "$ACTION" = "client-focus-out" ]; then 
    sketchybar --set '/tmux.window.*/' drawing=off
else
    sketchybar --set '/tmux.window.*/' drawing=on
fi
    


