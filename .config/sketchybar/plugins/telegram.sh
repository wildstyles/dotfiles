#!/usr/bin/env bash


STATUS_LABEL=$(lsappinfo info -only StatusLabel "Telegram")
if [[ $STATUS_LABEL =~ \"label\"=([^[:space:]{}]+) ]]; then
    LABEL="${BASH_REMATCH[1]}"
    LABEL=${LABEL//\"/}

    if [[ $LABEL == kCFNULL ]]; then
        ICON_COLOR="0xffa6da95"
        LABEL=""
    elif [[ $LABEL == "•" ]]; then
        ICON_COLOR="0xffeed49f"
    elif [[ $LABEL =~ ^[0-9]+$ ]]; then
        ICON_COLOR="0xffed8796"
    else
        exit 0
    fi
else
    exit 0
fi

sketchybar --set "$NAME" icon=":telegram:" label="$LABEL" icon.color="$ICON_COLOR"

