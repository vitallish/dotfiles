#!/usr/bin/env sh

if [[ $SENDER == "routine" ]] || [[ $SENDER == "clockifyupdate" ]]; then
		CUR_DURATION=$(clockify-cli show current -D)

		if [[ $CUR_DURATION == "" ]]; then
				ICON_COLOR="0xffe6e6e6"
				sketchybar --set $NAME label.drawing=off
		else
				sketchybar --set $NAME label.drawing=on
				ICON_COLOR="0xff3366ff"
		fi

		sketchybar --set $NAME label="${CUR_DURATION}" icon.color=${ICON_COLOR}
fi


if [[ $SENDER == "mouse.entered" ]]; then
		sketchybar --set $NAME background.drawing=on 
		sketchybar -m --set $NAME popup.drawing=on

fi

if [[ $SENDER == "mouse.exited" ]]; then
		sketchybar --set $NAME background.drawing=off
		sketchybar -m --set $NAME popup.drawing=off
fi

if [[ $SENDER == "mouse.clicked" ]]; then
		CUR_DURATION=$(clockify-cli show current -D)

		if [[ $CUR_DURATION == "" ]]; then
				clockify-cli clone last -i=0
		else
				clockify-cli out
		fi
		sketchybar --trigger clockifyupdate
fi

