#!/bin/bash

# If your system is compromised, likely one of the first pieces of context a hacker will look at is your console history.
# If you're like me, this isn't cleared very often.
# As such, this script's purpose is to automatically remove console history using a separate SSH connection into the remote machine.

remote_host="127.0.0.1"
remote_user="base"
remote_port="5024"

while true; do
  ssh -T "${remote_user}@${remote_host}" -p "${remote_port}" <<'EOF'
  for user in $(awk -F: '{print $1}' /etc/passwd); do
    history_file="/home/$user/.bash_history"
    if [ -f "$history_file" ]; then
      echo "Clearing history for user: $user"
      cat /dev/null > "$history_file"
    fi
  done
EOF
  sleep 120
done
