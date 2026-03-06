#! /bin/zsh

# Source shared task helper functions
source ~/.config/waybar/task-helpers.sh

timewstatus=$(timew get dom.active)

if [ "$timewstatus" -eq "1" ]; then
  text=$(timew get dom.active.duration)
  tooltip=$(timew | head -n 1 | sed "s/\"/'/g")
  class="active"
else
  text="󱎬"
  tooltip="No active time tracking"
  tooltip2=$(get_task_details $(get_next_task_id))
  tooltip="${tooltip}\n${tooltip2}"

  class="inactive"
fi

# -n - null input, -c compact output is necessary for waybar
# ARGS.named is a special jq thing -uses arg names
JSON_STRING=$( jq -nc \
  --arg text    "$text" \
  --arg tooltip "$tooltip" \
  --arg class   "$class" \
  '$ARGS.named')

echo $JSON_STRING
