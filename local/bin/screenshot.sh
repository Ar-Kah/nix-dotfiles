#!/bin/bash

SAVE_DIR="$HOME/Pictures/Screenshots"
FILENAME="$SAVE_DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

mkdir -p "$SAVE_DIR"

# Only proceed if scrot exits cleanly (user selected an area)
if scrot -s "$FILENAME"; then
    # Copy to clipboard
    if command -v xclip &> /dev/null; then
        xclip -selection clipboard -target image/png -i "$FILENAME"
    fi

    # Trigger notification via notify-send (AwesomeWM naughty picks this up)
    if command -v notify-send &> /dev/null; then
        notify-send "Screenshot Taken" "Saved to $FILENAME and copied to clipboard."
    fi
fi
