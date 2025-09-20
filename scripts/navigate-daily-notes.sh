#!/usr/bin/env bash

current_year=$(date +"%Y")
current_month_num=$(date +"%m")
current_day=$(date +"%d")
current_weekday=$(date +"%A")
current_month_abbr=$(date +"%b")

# Specify below the directory in which you want to create your daily note
note_dir=~/Projects/karabiner/notes/${current_year}-${current_month_abbr}
sesson_name=config
window_name=todo
tmux="/opt/homebrew/bin/tmux"

# Construct the directory structure and filename
note_name=${current_year}-${current_month_num}-${current_day}-${current_weekday}
full_path=${note_dir}/${note_name}.md

# Check if the directory exists, if not, create it
# if [ ! -d "$note_dir" ]; then
#   mkdir -p "$note_dir"
# fi
#
# # Create the daily note if it does not already exist
# if [ ! -f "$full_path" ]; then
#   cat <<EOF >"$full_path"
# # Contents
#
# ## Todo today
# EOF
# fi

current_session=$(${tmux} display-message -p '#S')
# I will start with just one todo file
todo_file_name="~/Projects/karabiner/md/todo.md"

if ${tmux} list-windows -t ${sesson_name} | grep -q "${window_name}"; then
    if [ $sesson_name != "$current_session" ]; then
        ${tmux} switch-client -t "$session_name"
    fi

    ${tmux} select-window -t ${sesson_name}:"${window_name}"

    ${tmux} send-keys -t ${session_name}:${window_name} ":edit $todo_file_name" C-m
else
    if [ $sesson_name != "$current_session" ]; then
        ${tmux} switch-client -t "$session_name"
    fi

    cd ~/Projects/karabiner && ${tmux} new-window -n "${window_name}" -t ${sesson_name}: 

    ${tmux} send-keys -t ${sesson_name}:${window_name} "nvim $todo_file_name" C-m
fi


