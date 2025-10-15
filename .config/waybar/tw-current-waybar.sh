#! /bin/zsh

# Source shared task helper functions
source ~/.config/waybar/task-helpers.sh

timewstatus=$(timew get dom.active)

if [ "$timewstatus" -eq "1" ]; then
  text=$(timew get dom.active.duration)
  tooltip=$(timew | head -n 1 | sed "s/\"/'/g")
  echo "{\"text\":\"$text\",\"tooltip\":\"$tooltip\"}"
else
  echo "{\"text\":\"󱎬\",\"tooltip\":\"No active time tracking\"}"
fi

