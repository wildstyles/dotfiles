#!/bin/bash

kb() {
    "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" "$@"
}

# Get the current item
current_item=$(kb --show-current-profile-name)

laptop_profile="Laptop profile"
default_profile="Default profile"

# Check current profile and switch
if [ "$current_item" = "$laptop_profile" ]; then
    echo "Switching from '$laptop_profile' to '$default_profile'"
    kb --select-profile "$default_profile"
else
    echo "Switching from '$current_item' to '$laptop_profile'"
    kb --select-profile "$laptop_profile"
fi

/opt/homebrew/bin/sketchybar --trigger keyboard_change
