#!/bin/bash

# Define the audio devices
DEVICE_1="EDIFIER R2850DB"
DEVICE_2="LG UltraFine Display Audio"
DEVICE_3="Динаміки MacBook Pro"

# Get the currently active audio device
CURRENT_DEVICE=$(/opt/homebrew/bin/SwitchAudioSource -c)

# Check if LG UltraFine Display Audio exists
LG_EXISTS=$(/opt/homebrew/bin/SwitchAudioSource -a -t output | grep -c "$DEVICE_2")

if [[ "$LG_EXISTS" -gt 0 ]]; then
    # Toggle between LG and EDIFIER
    if [[ "$CURRENT_DEVICE" == *"$DEVICE_2"* ]]; then
        /opt/homebrew/bin/SwitchAudioSource -s "$DEVICE_1"
        echo "Switched to: $DEVICE_1"
    elif [[ "$CURRENT_DEVICE" == *"$DEVICE_1"* ]]; then
        /opt/homebrew/bin/SwitchAudioSource -s "$DEVICE_2"
        echo "Switched to: $DEVICE_2"
    elif [[ "$CURRENT_DEVICE" == *"$DEVICE_3"* ]]; then
        /opt/homebrew/bin/SwitchAudioSource -s "$DEVICE_2"
        echo "Switched to: $DEVICE_2"
    else
        /opt/homebrew/bin/SwitchAudioSource -s "$DEVICE_3"
        echo "Switched to: $DEVICE_3"
    fi
else
    # Toggle between MacBook speakers and EDIFIER
    if [[ "$CURRENT_DEVICE" == *"$DEVICE_3"* ]]; then
        /opt/homebrew/bin/SwitchAudioSource -s "$DEVICE_1"
        echo "Switched to: $DEVICE_1"
    elif [[ "$CURRENT_DEVICE" == *"$DEVICE_1"* ]]; then
        /opt/homebrew/bin/SwitchAudioSource -s "$DEVICE_3"
        echo "Switched to: $DEVICE_3"
    else
        echo "Current device is neither $DEVICE_1 nor $DEVICE_3."
    fi
fi
