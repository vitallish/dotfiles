#!/bin/bash
STATE="$(echo "$INFO" | jq -r '.state')"

if [ "$STATE" = "playing" ]; then
  APP="$(echo "$INFO" | jq -r '.app')"
  MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
  sketchybar --set $NAME label="$MEDIA" drawing=on click_script="osascript -e 'tell application \"$APP\" to activate'"
else
  sketchybar --set $NAME drawing=off
fi

