#!/bin/bash

kb() {
    "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" "$@"
}

# Get the current item
current_item=$(kb --show-current-profile-name)

laptop_profile_en="Laptop profile EN"
laptop_profile_uk="Laptop profile UK"

default_profile_en="Default profile EN"
default_profile_uk="Default profile UK"

# Check current profile and switch
case "$current_item" in
    "$laptop_profile_en")
        echo "Switching from '$laptop_profile_en' to '$default_profile_en'"
        kb --select-profile "$default_profile_en"
        ;;
    "$default_profile_en")
        echo "Switching from '$default_profile_en' to '$laptop_profile_en'"
        kb --select-profile "$laptop_profile_en"
        ;;
    "$laptop_profile_uk")
        echo "Switching from '$laptop_profile_uk' to '$default_profile_uk'"
        kb --select-profile "$default_profile_uk"
        ;;
    "$default_profile_uk")
        echo "Switching from '$default_profile_uk' to '$laptop_profile_uk'"
        kb --select-profile "$laptop_profile_uk"
        ;;
    *)
        echo "Unknown profile: $current_item"
        ;;
esac

/opt/homebrew/bin/sketchybar --trigger keyboard_change
