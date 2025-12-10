
#!/bin/bash

original_url=$(pbpaste)
# Modify the URL to remove everything after '?' and append '.git'
url=$(echo "$original_url" | sed 's/[?].*//' | sed 's/$/.git/')

path=${original_url#*://*/}
# Alternatively for SSH URLs, extract the path after user@host:
# path=${original_url#*@*/}

project_name=$(echo "$path" | sed 's/[?].*//' | sed 's/.git$//' | awk -F'/' '{print $NF}')

echo "$project_name"

/Users/ruslanvanzula/Projects/dotfiles/scripts/kitty-switch-session.sh home

sock=$(ls /tmp/kitty-* 2>/dev/null | head -n1)

# Check if we found a socket, otherwise exit
if [[ -z "$sock" ]]; then
    echo "No Kitty instance found."
    exit 1
fi

/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action new_tab_with_cwd

/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" set-tab-title "$project_name"
sleep 0.3

/Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:${sock}" send-text cd ~/Projects 
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key enter

/Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:${sock}" send-text "git clone ""$url"" && cd $project_name"
/Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:${sock}" action send_key enter

