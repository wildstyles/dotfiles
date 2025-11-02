#!/bin/bash

# defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 28
#
#
# #!/usr/bin/env bash
# Toggle Rectangle’s top padding between 0 and 28px

# Read current value (defaults returns non-zero if unset → we treat that as 0)
current=$(defaults read com.knollsoft.Rectangle screenEdgeGapBottom 2>/dev/null || echo 0)

if [[ $current -eq 0 ]]; then
  new=28
else
  new=0
fi

# Write the new value
# defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 0
# defaults write com.knollsoft.Rectangle screenEdgeGapBottom -int $new


defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 0
defaults write com.knollsoft.Rectangle screenEdgeGapBottom -int 28
# Restart Rectangle to apply
killall Rectangle
open  /Applications/Rectangle.app

echo "Rectangle top-gap is now ${new}px."
