#!/bin/bash

# Check if there's an active task
if task +ACTIVE count | grep -q "^[1-9]"; then
    # Stop the active task
    task +ACTIVE stop
else
    # Start the most recently modified task
    last_task=$(task rc.report.wes.sort:modified- rc.verbose=nothing limit:1 wes | head -n 1 | cut -f1 -d' ')
    if [ -n "$last_task" ]; then
        task start "$last_task"
    fi
fi
