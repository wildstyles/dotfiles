#!/bin/bash

# this is jank and ugly, I know
LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"

# specify short layouts individually.
case "$LAYOUT" in
    "\"Colemak DH Matrix\"") SHORT_LAYOUT="CO";;
    "ABC") SHORT_LAYOUT="EN";;
    *) SHORT_LAYOUT="UK";;
esac

sketchybar --set keyboard icon=":keyboard:" label="$SHORT_LAYOUT"
