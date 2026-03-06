#!/bin/bash

# Get the ID of the next task that would be started
get_next_task_id() {
    task rc.report.wes.sort:modified- rc.verbose=nothing limit:1 wes 2>/dev/null |\
      head -n 1 | awk '{print $1}'
}

# Get formatted details of a task for waybar tooltip
get_task_details() {
    local task_id="$1"
    if [ -z "$task_id" ]; then
        echo ""
        return
    fi

    # Get task information in JSON format for easier parsing
    local task_json=$(task "$task_id" export 2>/dev/null)

    if [ -z "$task_json" ]; then
        echo ""
        return
    fi

    # Parse task details
    local description=$(echo "$task_json" | jq -r '.[0].description // ""' 2>/dev/null)
    local project=$(echo "$task_json" | jq -r '.[0].project // ""' 2>/dev/null)
    local tags=$(echo "$task_json" | jq -r '.[0].tags // [] | join(", ")' 2>/dev/null)

    # Build tooltip with pipes as separators
    local tooltip="Task #$task_id"
    [ -n "$description" ] && tooltip="$tooltip | $description"
    [ -n "$project" ] && tooltip="$tooltip | Project: $project"
    [ -n "$tags" ] && tooltip="$tooltip | Tags: $tags"

    echo "$tooltip"
}
