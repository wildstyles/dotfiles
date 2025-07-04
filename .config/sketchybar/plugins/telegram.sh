#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

STATUS_LABEL=$(lsappinfo info -only StatusLabel "Telegram")
if [[ $STATUS_LABEL =~ \"label\"=([^[:space:]{}]+) ]]; then
    LABEL="${BASH_REMATCH[1]}"
    LABEL=${LABEL//\"/}

    if [[ $LABEL == kCFNULL ]]; then
        ICON_COLOR=$WHITE
        LABEL=""
    elif [[ $LABEL == "•" ]]; then
        ICON_COLOR=$YELLOW
    elif [[ $LABEL =~ ^[0-9]+$ ]]; then
        ICON_COLOR=$GREEN
    else
        exit 0
    fi
else
    exit 0
fi

sketchybar --set "$NAME" icon=":telegram:" label="$LABEL" icon.color="$ICON_COLOR"

