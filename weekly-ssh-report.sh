#!/bin/bash

# Display a weekly SSH report
function display_weekly_report() {
    local report_date=$1

    # Print the report header with week ending date in Month Day format
    echo " "
    echo "Week ending $(date -d "$report_date" '+%b %e')"
    echo "===================="
    echo " "

    # Generate daily reports for the past week
    # For each day, run the daily-ssh-report.sh script with date parameter and all filter mode, and save output to a temporary file
    for i in {0..6}; do
        local day
        day=$(date --date="$report_date -$i days" +'%b %e')
        bash daily-ssh-report.sh "$day" all >"/tmp/ssh-failed-ip-$i.txt"
  done

    # Combine all daily reports, sort by IP address,
    # count the number of occurrences for each IP, sort by frequency,
    # select the top 5 IPs,
    # finally format the output, so it's closer to the tutorial sample
    cat /tmp/ssh-failed-ip-{0..6}.txt \
        | sort \
        | uniq -c \
        | sort -nr \
        | head -n 5 \
        | awk '{ printf "%-10s%-20s\n", $1, $2 }'

    echo " "
    echo "Number of failed password attempts over past week"
    echo "-------------------------------------------------"

    # Display the number of failed password attempts for each day of the past week
    # For each day, display the date in Month Day format,
    # Count the number of lines (IPs) in the corresponding daily report file
    for i in {0..6}; do
        local day
        day=$(date --date="$report_date -$i days" +'%b %e')
        echo -n "$(date -d "$day" '+%b %e'): "
        cat "/tmp/ssh-failed-ip-$i.txt" | wc -l
  done

    echo " "
    echo "Number of failed password attempts for valid logins over past week"
    echo "-------------------------------------------------"

    # Display the number of failed password attempts for valid logins over the past week
    # For each day, display the date in Month Day format,
    # run the 'daily-ssh-report.sh' script with date parameter and valid filter mode,
    # count the number of lines (IPs) in the output
    for i in {0..6}; do
        local day
        day=$(date --date="$report_date -$i days" +'%b %e')
        echo -n "$(date -d "$day" '+%b %e'): "
        bash daily-ssh-report.sh "$day" valid | wc -l
  done

    # Remove the temporary files generated
    rm /tmp/ssh-failed-ip-*.txt
}

# Main function
function main() {
    # Set default values for global variables
    local report_date
    report_date=$(date +'%Y-%m-%d')

    # Handle input
    if [ "$#" -eq 1 ]; then
        report_date=$1
  fi

    # Validate input date
    if ! date -d "$report_date" >/dev/null 2>&1; then
        echo "Error: Invalid date format."
        exit 1
  fi

    # Display the weekly SSH report
    display_weekly_report "$report_date"
}

# Call the main function with the command-line arguments
main "$@"
