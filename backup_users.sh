#!/bin/bash

# Backs up a set of specified user directories into a tarball

# Ensure an argument is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Ensure the file exists
if [[ ! -e "$1" ]]; then
  echo "Error: file '$1' does not exist"
  exit 1
fi

# Create backup directory if it does not exist
backup_dir="/tmp/bkp"
if [[ ! -d "${backup_dir}" ]]; then
  mkdir "${backup_dir}"
fi

# Loop through each username in the file
while read -r user_name; do
  # Check if the user exists
  if ! id "${user_name}" >/dev/null 2>&1; then
    echo "Error: user '${user_name}' does not exist"
    continue
  fi

  # Create backup file with current date
  backup_file="${backup_dir}/${user_name}-$(date +%F).tgz"

  # Create archive of user's home directory
  tar -czf "${backup_file}" "/home/${user_name}"

  # Output success message
  echo "Backup created for user '${user_name}' in file '${backup_file}'"
done < "$1"
