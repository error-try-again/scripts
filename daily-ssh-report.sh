#!/bin/bash

# Function to parse command line input and set global variables
function handle_input() {
    # If two arguments are passed, assign them to report_date and filter_mode variables
    # Otherwise if only one argument is passed, assign it to filter_mode variable and set report_date
    # to current month and day
    # If neither are passed, print usage message and exit with an error code
    if [ "$#" -eq 2 ]; then
        report_date=$1
        filter_mode=$2
    elif [ "$#" -eq 1 ]; then
        filter_mode=$1
        report_date=$(date +'%b %d')
    else
        echo "Usage: $0 quoted-report-date [all|valid|invalid]"
        exit 1
    fi
}

# Function to validate filter mode and report date
function validate_input() {
    # If filter_mode is not "all", "valid", or "invalid", print an error message and exit with
    # error code
    if [[ ! "$filter_mode" =~ ^(all|valid|invalid)$ ]]; then
        echo "Error: Invalid filter mode. Must be 'all', 'valid', or 'invalid'."
        exit 1
    fi

    # If report_date is not a valid date, print an error message and exit with error code
    if ! date -d "$report_date" >/dev/null 2>&1; then
        echo "Error: Invalid date format."
        exit 1
    fi
}

# Function to extract IP addresses of failed login attempts for invalid users
function handle_invalid_ips() {
    # Find lines in the log file that match the specified date and contain "Failed password" and "for invalid user"
    # Extract the IP address from each matching line
    grep "${report_date}" ${log_file} | grep "sshd.*Failed password.*for invalid user" |
    sed -E 's/.*from ([^ ]+).*/\1/'
}

# Function to extract IP addresses of failed login attempts for valid users
function handle_valid_ips() {
    # Find lines in the log file that match the specified date and contain "Failed password" but not "for invalid user"
    # Extract the IP address from each matching line
    grep "${report_date}" ${log_file} | grep -v "for invalid user" |
    grep "sshd.*Failed password" |
    sed -E 's/.*from ([^ ]+).*/\1/'
}

# Function to extract IP addresses of all failed login attempts
function handle_all_ips() {
    # Find lines in the log file that match the specified date and contain "Failed password"
    # Extract the IP address from each matching line
    grep "${report_date}" ${log_file} | grep "sshd.*Failed password" |
    sed -E 's/.*from ([^ ]+).*/\1/'
}

# Main function
function main() {
    log_file="/var/log/auth.log"
    handle_input "$@"
    validate_input

    # Extract the IP addresses of failed login attempts based on the specified filter mode
    if [[ "$filter_mode" == "invalid" ]]; then
        handle_invalid_ips
    elif [[ "$filter_mode" == "valid" ]]; then
        handle_valid_ips
    else
        handle_all_ips
    fi
}

# Call main function with command-line arguments
main "$@"
