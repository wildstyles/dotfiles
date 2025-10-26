#!/bin/bash

current_resolution=$(system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2 "x" $4}')

echo "$current_resolution current"


if [ "$current_resolution" = "4096x2304" ]; then
    /opt/homebrew/bin/displayplacer "id:FB576294-33BB-47D1-93D3-2057ECBFCF1C mode:17"
else
    /opt/homebrew/bin/displayplacer "id:FB576294-33BB-47D1-93D3-2057ECBFCF1C mode:15"
fi

