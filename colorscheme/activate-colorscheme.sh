
#!/usr/bin/env bash

source "$HOME/Projects/dotfiles/colorscheme/active-colorscheme.sh"
# Define the path to your starship.toml file
FILE_PATH="$HOME/Projects/dotfiles/.config/starship/starship.toml"


# Define the new color palette to replace the [palettes.onedark] section
NEW_COLORS=$(cat << EOF
red = '$color_red'
green = '$color_green'
dark_green = '$color_sapphire'
yellow = '$color_yellow'
white = '$color_white1'
EOF
)

# Escape slashes and other special characters in NEW_COLORS for safe sed replacement
# safe_colors=$(printf '%s\n' "$NEW_COLORS" | sed -e 's/[\/&]/\\&/g')
#
# echo "$safe_colors"

# Define the file path
#
sed -i.bak "/\[palettes.onedark\]/,/^\[/{ /^\[.*\]/!d; }" "$FILE_PATH"

echo "$NEW_COLORS" >> "$FILE_PATH"
