#!/bin/bash


tracking_info=$(timew)

task_name=$(echo "$tracking_info" | awk '/Tracking/ {print $2}')

get_total_time() {
    timew summary $task_name | awk 'NF {last=$NF} END {print last}'
}

total_time=$(get_total_time)

sketchybar --set $NAME label="$task_name - $total_time"

