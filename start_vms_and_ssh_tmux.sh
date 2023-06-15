#!/bin/bash

# The purpose of this script is to start a list of VirtualBox VMs (if they're not running) and then open a tmux session with separate panes SSHing into each of these VMs.
# Effectively automates away the initial interaction with each virtual machine

# Define an array of VM names
vms=("GW Router" "Git Server" "DokuWiki" "Cron Server" "Jump Box" "DHCP Server")

# Define an array of hosts and ports to connect to
hosts=(
  "base@127.0.0.1:5024"
  "base@127.0.0.1:5025"
  "base@127.0.0.1:5026"
  "base@127.0.0.1:5030"
  "base@127.0.0.1:5031"
  "base@127.0.0.1:5032"
)

# Define the path to the SSH public key
ssh_key_path="~/.ssh/virt_hosts_ssh.pub"

# Check if the VMs are running, and start them if they aren't
for vm in "${vms[@]}"
do
  if VBoxManage showvminfo "$vm" | grep "running (since" >/dev/null 2>&1; then
    echo "$vm is already running"
  else
    VBoxHeadless --startvm "$vm" &
    echo "Starting $vm"
  fi
done

# Wait for the VMs to start up
sleep 10

# Open tmux
tmux new-session -d -s ssh-session

# Loop through each host and add it to a new pane in the tmux session
for host in "${hosts[@]}"
do
  # Split the current pane vertically
  tmux split-window -v -c "#{pane_current_path}"

  # Resize the current pane
  tmux resize-pane -y 5

  # SSH into the current host in the new pane
  tmux send-keys "ssh -i $ssh_key_path -p ${host#*:} ${host%:*}" C-m
  
done

# Attach to the tmux session
tmux attach-session -t ssh-session
