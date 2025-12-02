#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# File to store previous session
SESSION_FILE="/tmp/kitty_previous_session"

if [[ -f "$SESSION_FILE" ]]; then
    # Source the file to load variables SESSION and ACTIVE_TAB_ID
    source "$SESSION_FILE"
else
    PREV_SESSION=""
    PREV_TAB_ID=""
    PREV_TAB_LENGTH=""
    PREV_FOCUSED_APP=""
fi

DOTFILES_SESSION="dotfiles"
SCOUT_SESSION="scout"
focused_app="$(osascript -e 'tell application "System Events" 
    get name of application processes whose frontmost is true
end tell'
)"

sock="$(ls /tmp/kitty-* 2>/dev/null | head -n1)"

DOTFILES_TABS=$(
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" ls -m session:${DOTFILES_SESSION} |
  jq --arg session_name $DOTFILES_SESSION '
    [.[] .tabs[] | {is_active, title, id, session_name: $session_name}] |
    to_entries | map(.value + {index: (.key + 1)})
  '
)
SCOUT_TABS=$(
  /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" ls -m session:${SCOUT_SESSION} |
  jq --arg session_name $SCOUT_SESSION '
    [.[] .tabs[] | {is_active, title, id, session_name: $session_name}] |
    to_entries | map(.value + {index: (.key + 1)})
  '
)

ALL_TABS=$(jq -s 'add' <<< "$DOTFILES_TABS $SCOUT_TABS")
active_tab_id=$(echo "$ALL_TABS" | jq -r '.[] | select(.is_active == true) | .id')
TABS_LENGTH=$(echo "$ALL_TABS" | jq 'length')

if [[ "$PREV_TAB_LENGTH" != "$TABS_LENGTH" ]]; then
  sketchybar --remove '/kitty.window.*/'

  echo "$ALL_TABS" | jq -c '.[]' | while IFS='' read -r line; do
     tab_id=$(echo "$line" | jq '.id')
     tab_index=$(echo "$line" | jq '.index')
     tab_sesion=$(echo "$line" | jq -r '.session_name')
     prev_tab_index=$((tab_index - 1))
     tab_title=$(echo "$line" | jq -r '.title' | sed 's/[^~]*\(~.*\)/\1/')

     sketchybar --add item kitty.window."$tab_sesion"."$tab_id" left \
         --set kitty.window."$tab_sesion"."$tab_id" \
         drawing=off \
         label="$tab_index $tab_title" \
         icon.padding_left=8 \
         label.color="$WHITE" \
         icon.color="$WHITE" \
         background.color="$ITEM_BG_COLOR" \
         label.padding_right=10

     sleep 0.08
  done
  
  sleep 0.2
fi

if [ "$focused_app" = "kitty" ]; then 
  if [[ "$SESSION" != "$PREV_SESSION" ]] || [[ "$PREV_FOCUSED_APP" != "kitty" ]] || [[ "$PREV_TAB_LENGTH" != "$TABS_LENGTH" ]]; then
    sketchybar --set '/kitty.window.*/' label.color="$WHITE" background.color="$ITEM_BG_COLOR" drawing=off
    sleep 0.08

    ACTIVE_SESSION=$SESSION

    if [ -z "$SESSION" ]; then
      ACTIVE_SESSION="$PREV_SESSION"
    fi

    sketchybar --set kitty.window."$ACTIVE_SESSION"."$active_tab_id" label.color="$BAR_COLOR" background.color="$YELLOW"
    sketchybar --set "/kitty.window.$ACTIVE_SESSION.*/" drawing=on 
  else
    sketchybar --set "/kitty.window.$SESSION.*/" \
      label.color="$WHITE" \
      background.color="$ITEM_BG_COLOR"

    sketchybar --set kitty.window."$SESSION"."$active_tab_id" \
      label.color="$BAR_COLOR" \
      background.color="$YELLOW"
  fi
else
    sketchybar --set '/kitty.window.*/' drawing=off
fi

echo "PREV_SESSION=$SESSION" > "$SESSION_FILE"
echo "PREV_TAB_ID=$active_tab_id" >> "$SESSION_FILE"
echo "PREV_TAB_LENGTH=$TABS_LENGTH" >> "$SESSION_FILE"
echo "PREV_FOCUSED_APP=$focused_app" >> "$SESSION_FILE"

