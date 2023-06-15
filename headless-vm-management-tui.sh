#!/bin/bash

# Define an array of VM names
vms=("GW Router" "Git Server" "DokuWiki" "Cron Server" "Jump Box" "DHCP Server")

# Define the options menu
options=("Shutdown All" "Reboot All" "Startup All" "Quit")

# Loop until the user quits
while true; do
  # Print the options menu
  echo "Choose an option:"
  for i in "${!options[@]}"; do
    echo "$i) ${options[$i]}"
  done

  # Read the user's choice
  read -rp "Option: " choice

  # Handle the user's choice
  case $choice in
    0) # Shutdown all VMs
      for vm in "${vms[@]}"; do
        # Check if the VM is already powered off
        if VBoxManage showvminfo "$vm" | grep "powered off (since" >/dev/null 2>&1; then
          echo "$vm is already powered off"
        else
          VBoxManage controlvm "$vm" poweroff
          echo "$vm has been powered off"
        fi
      done
      ;;
    1) # Reboot all VMs
      for vm in "${vms[@]}"; do
        # Check if the VM is already powered off
        if VBoxManage showvminfo "$vm" | grep "powered off (since" >/dev/null 2>&1; then
          echo "$vm is powered off, cannot reboot"
        else
          VBoxManage controlvm "$vm" reset
          echo "$vm is rebooting"
        fi
      done
      ;;
    2) # Start all VMs
      for vm in "${vms[@]}"; do
        # Check if the VM is already running
        if VBoxManage showvminfo "$vm" | grep "running (since" >/dev/null 2>&1; then
          echo "$vm is already running"
        else
          # Check if the VM is in a saved state
          if VBoxManage showvminfo "$vm" | grep "saved (since" >/dev/null 2>&1; then
            VBoxManage startvm "$vm" --type headless
            echo "$vm is starting up from saved state"
          else
            # Start the VM in headless mode
            VBoxHeadless --startvm "$vm" &
            echo "$vm is starting up"
          fi
        fi
      done
      ;;
    3) # Quit the script
      exit 0
      ;;
    *) # Invalid option
      echo "Invalid option, please choose again"
      ;;
  esac
done
