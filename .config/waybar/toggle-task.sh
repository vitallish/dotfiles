#!/bin/bash

# Source shared task helper functions
source ~/.config/waybar/task-helpers.sh

# Check if there's an active task
if task +ACTIVE count | grep -q "^[1-9]"; then
    # Stop the active task
    task +ACTIVE stop
else
    # Start the most recently modified task
    next_task=$(get_next_task_id)
    if [ -n "$next_task" ]; then
        task start "$next_task"
    fi
fi
