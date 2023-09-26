#!/bin/bash

# Check if a Python package is installed
check_package() {
    python3 -c "import $1" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "$1 is not installed. Installing..."
        pip install $1
    else
        echo "$1 is already installed."
    fi
}

# Check and install openpyxl
check_package openpyxl

# Check and install pandas
check_package pandas

# Check if file argument is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_xlsx_file> <path_to_output_csv_file>"
    exit 1
fi

# Convert xlsx to csv using Python and Pandas
python3 -c "
import pandas as pd
import sys

# Read the xlsx file
data = pd.read_excel('$1')

# Save to csv
data.to_csv('$2', index=False)
"

exit 0
