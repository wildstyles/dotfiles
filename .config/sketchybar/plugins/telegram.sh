#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

STATUS_LABEL=$(lsappinfo info -only StatusLabel "Telegram")
STATUS_LABEL=$(echo "$STATUS_LABEL" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
# that's the value after system reboot
EXPECTED_LABEL='"StatusLabel"=[ NULL ]'

if [[ "$STATUS_LABEL" == "$EXPECTED_LABEL" ]]; then
  ICON_COLOR=$WHITE
  LABEL=""
else 
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
fi

sketchybar --set "$NAME" icon=":telegram:" label="$LABEL" icon.color="$ICON_COLOR"

