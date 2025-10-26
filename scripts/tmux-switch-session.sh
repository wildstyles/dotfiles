#!/bin/bash

session_name="$1"

# Check if the session exists
if /opt/homebrew/bin/tmux  ls | grep -q "$session_name"; then
  # Switch to the session
  /opt/homebrew/bin/tmux switch-client -t "$session_name"
else
  echo "Session '$session_name' not found."
fi
