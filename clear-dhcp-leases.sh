#!/bin/bash

# Clear old DHCP leases from DHCP server

# Define the path to the dhcpd.leases file
dhcpd_leases_file="/var/lib/dhcp/dhcpd.leases"

# Parse the dhcpd.leases file and remove duplicate entries
awk '/lease/{ip=$2}/hardware/{mac=$3}/}/{print ip" "mac}' "$dhcpd_leases_file" | sort -u -k1,1 | awk '{print "host "$2" { hardware ethernet "$3"; fixed-address "$1"; }"}' > /tmp/dhcpd.conf

# Copy the temporary configuration file to the dhcpd.conf file
sudo mv /tmp/dhcpd.conf /etc/dhcp/dhcpd.conf

# Restart the DHCP server
sudo service isc-dhcp-server restart
