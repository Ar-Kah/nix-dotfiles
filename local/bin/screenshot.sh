# Define where to save the image and name it with the current date and time
SAVE_DIR="$HOME/Pictures/Screenshots"
FILENAME="$SAVE_DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Create the directory if it does not exist
mkdir -p "$SAVE_DIR"

# Take the screenshot by dragging a selection (-s for select area with mouse)
scrot -s "$FILENAME"

# Optional: Print a notification if notify-send is available
if command -v notify-send &> /dev/null; then
    notify-send "Screenshot Saved" "Saved to $FILENAME"
fi
