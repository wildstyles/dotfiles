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

# Define the headers you want to keep
keep_headers=("accept" "authorization")

# Get the curl command from the clipboard
original_curl=$(pbpaste)
modified_curl=$(echo "$original_curl")

if $strip_headers; then
  modified_curl=$(echo "$original_curl" | sed -n '/^curl/p')
fi

if $replace_urls; then
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-scott.api.scoutgg-stg.net|http://localhost:3040|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-scott.api.scoutgg-stg.net|http://localhost:3040|g')

  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-wallet.api.scoutgg-stg.net|http://localhost:3020|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-wallet.api.scoutgg-stg.net|http://localhost:3020|g')

  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-game.api.scoutgg-stg.net|http://localhost:3090|g')
  modified_curl=$(echo "$modified_curl" | sed 's|https://fanteam-qa-game.api.scoutgg-stg.net|http://localhost:3090|g')
fi

# Process each header line and check the header name
if $strip_headers; then
  while IFS= read -r line; do
      # Extract content within single quotes
      content=$(echo "$line" | sed -n "s/.*'\([^']*\)'.*/\1/p")
      # Extract the header name by splitting before the colon and trimming spaces
      header_name=$(echo "$content" | cut -d: -f1 | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

      # Check if the extracted header name is in the keep_headers array
      for keep in "${keep_headers[@]}"; do
          if [[ "$header_name" == "$keep" ]]; then
              # Format and add it to modified_headers
              modified_curl+=$'\n'"  -H '$content' \\"
              break
          fi
      done
  done <<< "$(echo "$original_curl" | sed -n '/-H/p')"
fi

# Output the filtered headers for verification
echo -e "$modified_curl" | pbcopy

SESSION="scout"
WINDOW="posting"

# Select the specific window in the tmux session
/opt/homebrew/bin/tmux switch-client -t "$SESSION"
/opt/homebrew/bin/tmux select-window -t "$SESSION:$WINDOW"

/opt/homebrew/bin/tmux send-keys -t "$SESSION:$WINDOW" "C-c" C-m
sleep 0.5
# Send the `posting` command followed by Enter
/opt/homebrew/bin/tmux send-keys -t "$SESSION:$WINDOW" "posting" C-m

sleep 0.5
#
osascript -e 'tell application "System Events" to keystroke "v" using command down'
