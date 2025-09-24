#!/bin/bash

# Move entire tabbed group script for Hyprland
# If window is in a group, moves the entire group in the specified direction

direction="$1"

# Get current window info
current_window=$(hyprctl activewindow -j)
current_grouped=$(echo "$current_window" | jq -r '.grouped[]' 2>/dev/null | wc -l)

if [ "$current_grouped" -gt 1 ]; then
    # Window is in a group, use movewindoworgroup to move the entire group
    hyprctl dispatch movewindoworgroup "$direction"
else
    # Window is not in a group, just move it normally
    hyprctl dispatch movewindow "$direction"
fi