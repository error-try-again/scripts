#!/bin/bash

# Specify the path to your script that you want to background
script_path="$1"
date=$(date +%Y%m%d%H%M%S)

# Start a detached tmux session that runs the script
tmux new-session -d -s mysession_${date} "$script_path"
