
# Define where to save the image and name it with the current date and time
SAVE_DIR="$HOME/Pictures/Screenshots"
FILENAME="$SAVE_DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Create the directory if it does not exist
mkdir -p "$SAVE_DIR"

# Only proceed if scrot succeeds (user selects an area and doesn't hit Esc)
if scrot -s "$FILENAME"; then
    # Copy the saved image to the clipboard
    if command -v xclip &> /dev/null; then
        xclip -selection clipboard -target image/png -i "$FILENAME"
    fi

    # Print notification
    if command -v notify-send &> /dev/null; then
        notify-send "Screenshot Saved" "Saved to $FILENAME and copied to clipboard!"
    fi
fi
