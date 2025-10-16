#!/bin/bash

# Extract and display launcher mode section from sway config
sed -n '/^mode "launcher"/,/^}/p' ~/.config/sway/config

# Keep the terminal open until user presses a key
read -r
