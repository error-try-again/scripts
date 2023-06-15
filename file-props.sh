#!/bin/bash

# Output the properties of a file, including its name, type, size in bytes, the number of lines it contains, and the date it was last modified.

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

# Get file properties
fileName=$(basename "$1")
fileType=$(file -b "$1")
fileSize=$(wc -c < "$1")
numLines=$(wc -l < "$1")
modDate=$(date -r "$1" +"%Y-%m-%d")

# Output results
echo "Filename: $fileName"
echo "File type: $fileType"
echo "File size: $fileSize bytes"
echo "Number of lines: $numLines"
echo "Last modified date: $modDate"
