#!/bin/bash

# This function continuously writes the current date and time to a file called '/tmp/imalive'
# It does this every 600 seconds (10 minutes)
# It will stop doing this when a file called '/tmp/nolongerlive' is found
write_alive() {
  while true; do
    if [[ -e /tmp/nolongerlive ]]; then
      # If /tmp/nolongerlive exists, break out of the loop
      break
    fi
    # Append the current date to /tmp/imalive
    date >> /tmp/imalive
    # Sleep for 600 seconds before the next iteration
    sleep 600
  done
}
  # Experimental daemon used to run a specific timed action every 10 minutes until a conditional is met
  # Check if the first script argument is 'fork'
  if [ "$1" == "fork" ]; then
    # If 'fork' argument is supplied, start the write_alive function as a background task
    # This is indicated by the ampersand (&) at the end
    write_alive &
    # Use 'disown' to remove the function from the shell's job table
    # This prevents the shell from sending HUP signal to the function when the shell session is terminated
    disown
  else
    # If 'fork' argument is not supplied, run the script again with 'fork' argument
    # Use 'nohup' to ignore the HUP (hangup) signal when the terminal session ends
    # Redirect standard output (stdout) and standard error (stderr) to /dev/null to prevent writing to the nohup.out file
    nohup "$0" fork > /dev/null 2>&1 &
  fi
