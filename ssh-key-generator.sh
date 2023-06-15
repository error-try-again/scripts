#!/bin/bash

# The purpose of this script is to automate the process of setting up passwordless SSH authentication for multiple hosts.

# Prompt for the remote server username
read -p "Enter remote server username: " remote_user

# Prompt for key name
read -p "Enter a name for the new SSH key (e.g. my_key): " key_name

# Generate SSH key pair if it doesn't exist
if [ ! -f ~/.ssh/$key_name ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/$key_name -N ''
fi

# Ask for number of hosts and key type
read -p "Enter number of remote hosts to copy key to: " num_hosts
read -p "Should the same key be used for all hosts? (y/n): " same_key

# Copy public key to remote server(s)
for ((i=1; i<=$num_hosts; i++)); do
    read -p "Enter hostname of remote server #$i: " remote_host
    if [[ "$same_key" == "y" ]]; then
        ssh-copy-id -i ~/.ssh/$key_name.pub "$remote_user@$remote_host"
    else
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/$key_name_$i -N ''
        ssh-copy-id -i ~/.ssh/$key_name_$i.pub "$remote_user@$remote_host"
    fi
    if [ $? -ne 0 ]; then
        echo "Failed to copy SSH key to $remote_host"
        exit 1
    fi
done

echo "SSH key pair generated and copied to remote server(s)."
