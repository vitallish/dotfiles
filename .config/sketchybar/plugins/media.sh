#!/bin/bash
STATE="$(echo "$INFO" | jq -r '.state')"


if [[ $SENDER == "media_change" ]]; then
if [ "$STATE" = "playing" ]; then
  APP="$(echo "$INFO" | jq -r '.app')"
  MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
  sketchybar --set $NAME label="$MEDIA" drawing=on click_script="osascript -e 'tell application \"$APP\" to activate'"
else
  sketchybar --set $NAME drawing=off
fi
fi

if [[ $SENDER == "mouse.entered" ]]; then
		sketchybar --set $NAME background.drawing=on 
fi

if [[ $SENDER == "mouse.exited" ]]; then
		sketchybar --set $NAME background.drawing=off
fi

if [[ $SENDER == "mouse.clicked" ]]; then
  APP="$(echo "$INFO" | jq -r '.app')"
  osascript -e "tell application \"$APP\" to activate"
fi

