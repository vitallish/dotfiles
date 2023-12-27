#!/usr/bin/env sh

if [[ $SENDER == "routine" ]]; then
CUR_DURATION=$(clockify-cli show current -D)

ICON="󱃑"

if [[ $CUR_DURATION == "" ]]; then
		ICON_COLOR="0xffe6e6e6"
		sketchybar --set $NAME label.drawing=off
else
		sketchybar --set $NAME label.drawing=on
        ICON_COLOR="0xff3366ff"
fi

sketchybar --set $NAME icon=$ICON label="${CUR_DURATION}" icon.color=${ICON_COLOR}

fi


if [[ $SENDER == "mouse.entered" ]]; then
		sketchybar --set $NAME background.drawing=on 
		sketchybar -m --set $NAME popup.drawing=on

fi

if [[ $SENDER == "mouse.exited" ]]; then
		sketchybar --set $NAME background.drawing=off
		sketchybar -m --set $NAME popup.drawing=off
fi

