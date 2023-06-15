
Experiment: keep_alive.sh
==============================================

### DESCRIPTION:
The script is designed to run a long-lasting task in the background, for example, to continuously write the current date and time to a file every 10 minutes. This will continue even after the terminal session ends. The task can be stopped by creating a file in a specific location, which can be useful in situations where a long-term background process is required.
### FILE LOCATION:
/tmp/imalive  -- File where the current date and time is written.
/tmp/nolongerlive -- Create this file to stop the script.

### USAGE:

1. Give permissions & run the script:

`chmod + keep_alive.sh && ./keep_alive.sh`

2. Stop the script:

  `touch /tmp/nolongerlive`

3. Check the script's output:

 `cat /tmp/imalive`

This command will display the contents of the '/tmp/imalive' file in your terminal, showing each timestamp that the script has written.
