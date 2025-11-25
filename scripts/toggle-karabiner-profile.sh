#!/bin/bash

kb() {
    "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" "$@"
}

# Get the current item
current_item=$(kb --show-current-profile-name)
LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"

laptop_profile_en="Laptop profile EN"
laptop_profile_uk="Laptop profile UK"

default_profile="Default profile"

if [ "$current_item" = "$default_profile" ]; then
  if [ "$LAYOUT" = "ABC" ]; then
    kb --select-profile "$laptop_profile_en"
  else
    kb --select-profile "$laptop_profile_uk"
  fi
else
    echo "Switching from Laptop Profile to '$default_profile'"
    kb --select-profile "$default_profile"
fi

/opt/homebrew/bin/sketchybar --trigger keyboard_change
