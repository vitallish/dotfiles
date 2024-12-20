#!/usr/bin/env sh

if [ $SENDER = "routine" ] || [ $SENDER = "twupdate" ]; then
		CUR_DURATION=$(./plugins/twscript.sh)

		if [[ $CUR_DURATION == "NR" ]]; then
				ICON_COLOR="0xffe6e6e6"
				sketchybar --set $NAME label.drawing=off
		else
				sketchybar --set $NAME label.drawing=on
				ICON_COLOR="0xff33bdff"
		fi

		sketchybar --set $NAME label="${CUR_DURATION}" icon.color=${ICON_COLOR}
fi


if [[ $SENDER == "mouse.entered" ]]; then
		sketchybar --set $NAME background.drawing=on 
		sketchybar -m --set $NAME popup.drawing=on
    sketchybar --set tw.month.report \
                label="$(timew wes :month | head -n 3 | tail -n 1 | cut -c 25-35 | xargs)"
fi

if [[ $SENDER == "mouse.exited" ]]; then
		sketchybar --set $NAME background.drawing=off
		sketchybar -m --set $NAME popup.drawing=off
fi

#if [[ $SENDER == "mouse.clicked" ]]; then
# 		CUR_DURATION=$(./twscript.sh)
#
# 		if [[ $CUR_DURATION == "NR" ]]; then
# 				clockify-cli clone last -i=0
# 		else
# 				clockify-cli out
# 				sketchybar --set clockify.month.report \
# 						label="$(clockify-cli report this-month --billable -D)" 
# 		fi
# 		sketchybar --trigger clockifyupdate
# fi

