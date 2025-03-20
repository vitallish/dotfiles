#!/bin/zsh
echo "$1" > ~/.skhd_mode
echo "Mode: $1"


# Declare an associative array for mode-to-color mapping
declare -A mode_colors

# Populate the associative array with mode-color pairs
# # Populate the associative array with mode-color pairs
mode_colors=(
    "default" "0xffe2e2e3"   # Light gray/white
    "window" "0xff61afef"    # Blue
    "passthrough" "0xffee8e8f" # Red
    "launcher" "0xff7bb77b"  # Green
    "system" "0xffc8a361"    # Yellow/Brown
)


# Directly access the color for the current mode from the array
# Retrieve mode from the first argument
current_mode="$1"

# Directly access the color for the current mode from the array
active_color="${mode_colors[$current_mode]}"


# Check if the mode is valid and color is retrieved
if [ -z "$active_color" ]; then
    echo "Error: Invalid mode specified."
    exit 1
fi

borders active_color=${active_color}

