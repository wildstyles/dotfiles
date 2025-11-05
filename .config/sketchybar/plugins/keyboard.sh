#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"

kb() {
    "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" "$@"
}

# Get the current item
current_item=$(kb --show-current-profile-name)

laptop_profile="Laptop profile"
default_profile="Default profile"

# Set icon based on layout
if [ "$LAYOUT" == "ABC" ]; then
    ICON="􀺑"
else
    ICON="􀇳"
fi

# Set color based on current icon
if [ "$current_item" == "$laptop_profile" ]; then
    COLOR=$YELLOW  # Set yellow if current icon equals the new icon
else
    COLOR=$WHITE   # Set white otherwise
fi


sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"

