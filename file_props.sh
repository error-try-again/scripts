#!/bin/bash

# Output the properties of a file, including its name, type, size in bytes, the number of lines it contains, and the date it was last modified.

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

# Get file properties
file_name=$(basename "$1")
file_type=$(file -b "$1")
file_size=$(wc -c < "$1")
num_lines=$(wc -l < "$1")
mod_date=$(date -r "$1" +"%Y-%m-%d")

# Output results
echo "Filename: ${file_name}"
echo "File type: ${file_type}"
echo "File size: ${file_size} bytes"
echo "Number of lines: ${num_lines}"
echo "Last modified date: ${mod_date}"
