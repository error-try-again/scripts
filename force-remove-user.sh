#!/bin/bash

set -euo pipefail

function user_exists {
    id "$1" &> /dev/null
}

function is_system_user {
    local uid
    uid=$(id -u "$1")
    [[ $uid -lt 1000 ]]
}

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME="$1"

if ! user_exists "$USERNAME"; then
    echo "Error: User $USERNAME does not exist!"
    exit 2
fi

if is_system_user "$USERNAME"; then
    echo "Error: $USERNAME is a system user. Aborting."
    exit 3
fi

# Kill all processes owned by the user
pkill -u "$USERNAME" && echo "Killed processes owned by $USERNAME"

# Waiting a moment to ensure processes are terminated
sleep 2

# Forcefully kill any remaining processes
pkill -9 -u "$USERNAME" && echo "Forcefully killed any remaining processes owned by $USERNAME"

# Remove the user's home directory, mail spool, and user account
userdel -r "$USERNAME" && echo "Removed user account, home directory, and mail spool for $USERNAME"

# Remove the user from any additional groups
deluser "$USERNAME" && echo "Removed $USERNAME from any additional groups"

# Remove user's crontab
crontab -r -u "$USERNAME" && echo "Removed crontab for $USERNAME"

echo "User $USERNAME completely removed."
