#!/usr/bin/env sh
# Usage: toggle_app.sh <AppName>
# Minimizes the app window if visible, restores+focuses if minimized, launches if not running.

APP="$1"

if [ -z "$APP" ]; then
    echo "Usage: toggle_app.sh <AppName>" >&2
    exit 1
fi

WIN=$(yabai -m query --windows | jq --arg app "$APP" '[.[] | select(.app == $app)][0]')
ID=$(echo "$WIN" | jq '.id')
MINIMIZED=$(echo "$WIN" | jq '.["is-minimized"]')

if [ "$ID" = "null" ] || [ -z "$ID" ]; then
    open -a "$APP"
elif [ "$MINIMIZED" = "true" ]; then
    yabai -m window --deminimize "$ID" 2>/dev/null
    yabai -m window --focus "$ID"
else
    yabai -m window "$ID" --minimize
fi
