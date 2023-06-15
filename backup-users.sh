#!/bin/bash

# Backs up a set of specified user directories into a tarball

# Ensure an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Ensure the file exists
if [ ! -e "$1" ]; then
  echo "Error: file '$1' does not exist"
  exit 1
fi

# Create backup directory if it does not exist
backupDir="/tmp/bkp"
if [ ! -d "$backupDir" ]; then
  mkdir "$backupDir"
fi

# Loop through each username in the file
while read userName; do
  # Check if the user exists
  if ! id "$userName" >/dev/null 2>&1; then
    echo "Error: user '$userName' does not exist"
    continue
  fi

  # Create backup file with current date
  backupFile="$backupDir/$userName-$(date +%F).tgz"

  # Create archive of user's home directory
  tar -czf "$backupFile" "/home/$userName"

  # Output success message
  echo "Backup created for user '$userName' in file '$backupFile'"
done < "$1"
