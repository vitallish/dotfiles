#!/usr/bin/env sh

if [[ $SENDER == "mouse.entered" ]]; then
		sketchybar --set $NAME background.drawing=on 
		sketchybar -m --set $NAME popup.drawing=on

fi

if [[ $SENDER == "mouse.exited" ]]; then
		sketchybar --set $NAME background.drawing=off
		sketchybar -m --set $NAME popup.drawing=off
fi

