#!/bin/bash

set -euo pipefail

function user_exists {
    id "$1" &> /dev/null
}

function is_system_user {
    local uid
    uid=$(id -u "$1")
    [[ ${uid} -lt 1000 ]]
}

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username="$1"

if ! user_exists "${username}"; then
    echo "Error: User ${username} does not exist!"
    exit 2
fi

if is_system_user "${username}"; then
    echo "Error: ${username} is a system user. Aborting."
    exit 3
fi

# Kill all processes owned by the user
pkill -u "${username}" && echo "Killed processes owned by ${username}"

# Waiting a moment to ensure processes are terminated
sleep 2

# Forcefully kill any remaining processes
pkill -9 -u "${username}" && echo "Forcefully killed any remaining processes owned by ${username}"

# Remove the user's home directory, mail spool, and user account
userdel -r "${username}" && echo "Removed user account, home directory, and mail spool for ${username}"

# Remove the user from any additional groups
deluser "${username}" && echo "Removed ${username} from any additional groups"

# Remove user's crontab
crontab -r -u "${username}" && echo "Removed crontab for ${username}"

echo "User ${username} completely removed."
