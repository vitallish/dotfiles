#!/bin/bash

# Smart move script for Hyprland
# Moves windows into tabbed groups when the target is grouped,
# or moves out of group when already in a group

direction="$1"

# Get current window info
current_window=$(hyprctl activewindow -j)
current_grouped=$(echo "$current_window" | jq -r '.grouped[]' 2>/dev/null | wc -l)

# Function to get window in direction
get_window_in_direction() {
    local dir="$1"
    case "$dir" in
        "l") hyprctl -j clients | jq -r --argjson current "$(echo "$current_window")" '
            .[] | select(.workspace.id == $current.workspace.id) |
            select(.at[0] < $current.at[0]) |
            select(.at[1] < ($current.at[1] + $current.size[1]) and (.at[1] + .size[1]) > $current.at[1]) |
            sort_by(.at[0]) | last'
            ;;
        "r") hyprctl -j clients | jq -r --argjson current "$(echo "$current_window")" '
            .[] | select(.workspace.id == $current.workspace.id) |
            select(.at[0] > ($current.at[0] + $current.size[0])) |
            select(.at[1] < ($current.at[1] + $current.size[1]) and (.at[1] + .size[1]) > $current.at[1]) |
            sort_by(.at[0]) | first'
            ;;
        "u") hyprctl -j clients | jq -r --argjson current "$(echo "$current_window")" '
            .[] | select(.workspace.id == $current.workspace.id) |
            select(.at[1] < $current.at[1]) |
            select(.at[0] < ($current.at[0] + $current.size[0]) and (.at[0] + .size[0]) > $current.at[0]) |
            sort_by(.at[1]) | last'
            ;;
        "d") hyprctl -j clients | jq -r --argjson current "$(echo "$current_window")" '
            .[] | select(.workspace.id == $current.workspace.id) |
            select(.at[1] > ($current.at[1] + $current.size[1])) |
            select(.at[0] < ($current.at[0] + $current.size[0]) and (.at[0] + .size[0]) > $current.at[0]) |
            sort_by(.at[1]) | first'
            ;;
    esac
}

# If current window is in a group, move it out in the specified direction
if [ "$current_grouped" -gt 1 ]; then
    hyprctl dispatch moveoutofgroup
    sleep 0.1
    hyprctl dispatch movewindow "$direction"
else
    # Check if there's a window in the target direction
    target_window=$(get_window_in_direction "$direction")

    if [ "$target_window" != "null" ] && [ -n "$target_window" ]; then
        # Get target window address
        target_address=$(echo "$target_window" | jq -r '.address // empty')

        if [ -n "$target_address" ]; then
            # Focus the target window first
            hyprctl dispatch focuswindow "address:$target_address"
            sleep 0.1

            # Check if target window is grouped
            target_grouped=$(echo "$target_window" | jq -r '.grouped[]' 2>/dev/null | wc -l)

            # Focus back to original window
            current_address=$(echo "$current_window" | jq -r '.address')
            hyprctl dispatch focuswindow "address:$current_address"
            sleep 0.1

            if [ "$target_grouped" -gt 1 ]; then
                # Target is grouped, move into the group
                hyprctl dispatch moveintogroup "$direction"
            else
                # Target is not grouped, normal move
                hyprctl dispatch movewindow "$direction"
            fi
        else
            # No valid target, normal move
            hyprctl dispatch movewindow "$direction"
        fi
    else
        # No window in direction, normal move
        hyprctl dispatch movewindow "$direction"
    fi
fi