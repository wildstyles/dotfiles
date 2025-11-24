#!/bin/bash

kb() {
    "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" "$@"
}

# Get the current item
lang=${1:-"EN"}
current_item=$(kb --show-current-profile-name)


if [[ "$current_item" == *"$lang"* ]]; then
    # If it contains the substring, exit the script.
    exit 0
fi

laptop_profile_en="Laptop profile EN"
laptop_profile_uk="Laptop profile UK"

default_profile_en="Default profile EN"
default_profile_uk="Default profile UK"

# Check current profile and switch
if [ "$current_item" = "$default_profile_en" ]; then
    echo "Switching from '$default_profile_en' to '$default_profile_uk'"
    kb --select-profile "$default_profile_uk"
else
    echo "Switching from '$default_profile_uk' to '$default_profile_en'"
    kb --select-profile "$default_profile_en"
fi

/opt/homebrew/bin/sketchybar --trigger keyboard_change
