#!/usr/bin/env sh

STATUS_LABEL=$(lsappinfo info -only StatusLabel "$1")
if [[ $STATUS_LABEL =~ \"label\"=\"([^\"]*)\" ]]; then
    LABEL="${BASH_REMATCH[1]}"

    sketchybar --set $NAME icon.drawing=on
    if [[ $LABEL == "" ]]; then
        ICON_COLOR="0xffe6e6e6"
    elif [[ $LABEL == "•" ]]; then
        ICON_COLOR="0xffe6e6e6"
    elif [[ $LABEL =~ ^[0-9]+$ ]]; then
        ICON_COLOR="0xffa6da95"
    else
        exit 0
    fi
else
    sketchybar --set $NAME icon.drawing=off
  exit 0
fi

if [[ $SENDER = "mouse.clicked" ]]; then
    osascript -e "tell application \"$1\" to activate"
fi


if [[ $SENDER == "mouse.entered" ]]; then
		sketchybar --set $NAME background.drawing=on 
fi

if [[ $SENDER == "mouse.exited" ]]; then
		sketchybar --set $NAME background.drawing=off
fi




sketchybar --set $NAME label="${LABEL}" icon.color=${ICON_COLOR}

