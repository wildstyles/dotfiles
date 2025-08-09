#!/bin/bash

current_resolution=$(system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2 "x" $4}')


if [ "$current_resolution" = "3200x1800" ]; then
    /opt/homebrew/bin/displayplacer "id:FB576294-33BB-47D1-93D3-2057ECBFCF1C mode:15"
else
    /opt/homebrew/bin/displayplacer "id:FB576294-33BB-47D1-93D3-2057ECBFCF1C mode:10"
fi

