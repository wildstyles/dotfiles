#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

STATUS_LABEL=$(lsappinfo info -only StatusLabel "Slack")

if [[ $STATUS_LABEL =~ \"label\"=\"([^\"]*)\" ]]; then
    LABEL="${BASH_REMATCH[1]}"

    if [[ $LABEL == "" ]]; then
        ICON_COLOR=$WHITE
    elif [[ $LABEL == "•" ]]; then
        ICON_COLOR=$YELLOW
        LABEL=""
    elif [[ $LABEL =~ ^[0-9]+$ ]]; then
        ICON_COLOR=$GREEN
    else
        exit 0
    fi
else
  exit 0
fi

sketchybar --set $NAME icon=":slack:" label="${LABEL}" icon.color=${ICON_COLOR}
