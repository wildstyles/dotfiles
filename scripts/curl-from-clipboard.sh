#!/bin/bash

# Initialize flags
replace_urls=false
strip_headers=false

# Parse arguments
while getopts "rh" opt; do
  case $opt in
    r)
      replace_urls=true
      ;;
    h)
      strip_headers=true
      ;;
    *)
      echo "Usage: $0 [-r] [-h]"
      exit 1
      ;;
  esac
done

# Get the curl command from the clipboard
original_curl=$(pbpaste)
modified_curl=$(echo "$original_curl")

if $replace_urls; then
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-scott.api.scoutgg-stg.net|http://localhost:3040|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-scott.api.scoutgg-stg.net|http://localhost:3040|g')

  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-wallet.api.scoutgg-stg.net|http://localhost:3020|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-wallet.api.scoutgg-stg.net|http://localhost:3020|g')

  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-game.api.scoutgg-stg.net|http://localhost:3090|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-game.api.scoutgg-stg.net|http://localhost:3090|g')
fi

echo -e "$modified_curl" | pbcopy

SESSION="scout"
WINDOW="kulala"

/opt/homebrew/bin/tmux switch-client -t "$SESSION"
/opt/homebrew/bin/tmux select-window -t "$SESSION:$WINDOW"

CURRENT_COMMAND=$(/opt/homebrew/bin/tmux list-panes -t "$SESSION:$WINDOW" -F "#{pane_id} #{pane_index} #{pane_current_command}")                                       

pane_id=$(echo "$CURRENT_COMMAND" | awk '{print $1}')
pane_command=$(echo "$CURRENT_COMMAND" | awk '{print $3}')

if [ "$pane_command" == "nvim" ]; then
    /opt/homebrew/bin/tmux send-keys -t "$pane_id" Escape ":qa!" Enter
    echo "Sent :qa! to the nvim pane"
else
    /opt/homebrew/bin/tmux send-keys -t "$SESSION:$WINDOW" "C-c" C-m
    echo "No nvim process found in the specified pane"
fi

sleep 0.2

/opt/homebrew/bin/tmux send-keys -t "$SESSION:$WINDOW" "n mini-leagues.http" C-m

sleep 0.2

if $strip_headers; then
  /opt/homebrew/bin/tmux send-keys -t "$SESSION:$WINDOW" "," "k" "p"
else
  /opt/homebrew/bin/tmux send-keys -t "$SESSION:$WINDOW" "," "k" "c"
fi
