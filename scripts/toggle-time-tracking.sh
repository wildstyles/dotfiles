#!/usr/bin/env bash


TASK_NAME=${1:-"SGG"}
CURRENT_STATUS=$(/opt/homebrew/bin/timew)


get_total_time() {
    /opt/homebrew/bin/timew summary $TASK_NAME | awk 'NF {last=$NF} END {print last}'
}

if [[ "$CURRENT_STATUS" == "There is no active time tracking." ]]; then
    tracking_info=$(/opt/homebrew/bin/timew start "$TASK_NAME")
    task_name=$(echo "$tracking_info" | awk '/Tracking/ {print $2}')
    total_time=$(get_total_time)

    /opt/homebrew/bin/sketchybar --set timewarrior drawing=on label="$task_name - $total_time"
else
    /opt/homebrew/bin/timew stop
    /opt/homebrew/bin/sketchybar --set timewarrior drawing=off
fi


