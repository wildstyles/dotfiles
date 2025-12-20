
#!/usr/bin/env bash

source "$HOME/Projects/dotfiles/colorscheme/active-colorscheme.sh"
# Define the path to your starship.toml file
STARSHIP_PATH="$HOME/Projects/dotfiles/.config/starship/starship.toml"
KITTY_PATH="$HOME/Projects/dotfiles/.config/kitty/active-theme.conf"
LAZYGIT_PATH="$HOME/Projects/dotfiles/.config/lazygit/config.yml"


# Define the new color palette to replace the [palettes.onedark] section
STARSHIP_COLORS=$(cat << EOF
red = '$color_red'
green = '$color_green'
dark_green = '$color_sapphire'
yellow = '$color_yellow'
white = '$color_white1'
EOF
)

KITTY_COLORS=$(cat << EOF
foreground $color_white1
background $color_black
selection_foreground $color_white
selection_background $color_dark_grey
cursor $color_beige
cursor_text_color background
url_color $color_blue
mark1_foreground $color_black
mark1_background $color_red
active_tab_background $color_yellow1
active_border_color $color_yellow1
active_tab_foreground $color_dark_grey2
inactive_tab_foreground $color_white
inactive_tab_background $color_dark_grey2
transparent_background_colors $color_dark_grey@0.3 $color_headline_1@0.05 $color_headline_2@0.05 $color_headline_3@0.05 $color_headline_4@0.05 $color_headline_5@0.05 $color_headline_6@0.05
color0 $color_black
color8 $color_dark_grey
color1 $color_red
color9 $color_pink
color2 $color_green
color10 $color_sapphire
color3 $color_yellow
color11 $color_yellow1
color4 $color_blue
color12 $color_blue1
color5 $color_purple
color13 $color_purple1
color6 $color_cyan
color14 $color_cyan1
color7 $color_white1
color 15 $color_white
EOF
)


NEW_THEME_CONTENT=$(cat << EOF
  authorColors:
    '*': '$color_sapphire'
  theme:
    activeBorderColor: ['$color_yellow']
    inactiveBorderColor: ['$color_beige']
    searchingActiveBorderColor: ['$color_pink', bold]
    optionsTextColor: ['$color_blue']
    selectedLineBgColor: ['$color_dark_grey']
    cherryPickedCommitFgColor: ['$color_white']
    cherryPickedCommitBgColor: ['$color_orange']
    markedBaseCommitFgColor: ['$color_blue']
    markedBaseCommitBgColor: ['$color_yellow']
    unstagedChangesColor: ['$color_red']
    defaultFgColor: ['$color_beige1']
EOF
)

sed -i.bak "/\[palettes.onedark\]/,/^\[/{ /^\[.*\]/!d; }" "$STARSHIP_PATH"
# removes all after "authorColors" section
sed -i.bak '/^  authorColors:/,/^[^ ]/d' "$LAZYGIT_PATH"

echo "$STARSHIP_COLORS" >> "$STARSHIP_PATH"
echo "$KITTY_COLORS" > "$KITTY_PATH"

echo "$NEW_THEME_CONTENT" >> "$LAZYGIT_PATH"

