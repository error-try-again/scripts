
Experiment: keep_alive.sh
==============================================

### DESCRIPTION:
The script is designed to run a long-lasting task in the background, for example, to continuously write the current date and time to a file every 10 minutes. This will continue even after the terminal session ends. The task can be stopped by creating a file in a specific location, which can be useful in situations where a long-term background process is required.
### FILE LOCATION:
/tmp/imalive  -- File where the current date and time is written.
/tmp/nolongerlive -- Create this file to stop the script.

### USAGE:

1. Give permissions & run the script:

`chmod +x keep_alive.sh && ./keep_alive.sh`

2. Stop the script:

  `touch /tmp/nolongerlive`

3. Check the script's output:

 `cat /tmp/imalive`

This command will display the contents of the '/tmp/imalive' file in your terminal, showing each timestamp that the script has written.

Experiment: backup_users.sh
==============================================

### DESCRIPTION:
This script is designed to back up the home directories of a list of users, whose usernames are provided in a file. The file should contain one username per line. Backups are saved in tarball format (compressed using gzip) in the /tmp/bkp directory. The backup files are named in the format "username-YYYY-MM-DD.tgz", where "username" is the username and "YYYY-MM-DD" is the current date.

### USAGE:
1. Give permissions & run the script followed by the file containing the usernames:

  `chmod +x backup-users.sh && ./backup-users.sh usernames.txt`

Replace "usernames.txt" with your actual filename. If you make your script executable with 'chmod +x backup-users.sh', you can run it as follows:

  `./backup-users.sh usernames.txt`

2. Check the backups:

You can view the backups in the /tmp/bkp directory. The following command will list all files in this directory:

  `ls /tmp/bkp`

You can inspect individual backup files using the 'tar' command:

  `tar -tzf /tmp/bkp/username-YYYY-MM-DD.tgz`

Replace "username-YYYY-MM-DD.tgz" with your actual filename.

### NOTE:
The script requires root privileges to read all files in the users' home directories and to create the backups. Be sure to run it with 'sudo' if necessary.

### ERROR HANDLING:
The script performs basic error handling, including checking for an input file, checking if the input file exists, and checking if the usernames in the file exist on the system.
