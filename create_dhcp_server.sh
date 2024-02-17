#!/bin/bash

# Rapidly create a DHCP server on Ubuntu linux

# Install DHCP server
apt-get update
apt-get install isc-dhcp-server -y

# Backup current configuration file
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak

# Configure DHCP server
cat << EOF > /etc/dhcp/dhcpd.conf
option domain-name "internal-network";
option domain-name-servers 8.8.8.8, 8.8.4.4;

# Specify MAC address to bind host to IP via MAC
subnet 172.16.2.0 netmask 255.255.255.0 {
  range 172.16.2.100 172.16.2.200;
  option routers 172.16.2.2;
  option broadcast-address 172.16.2.255;

  host hosta {
    hardware ethernet 00:00:00:00:00:00;
    fixed-address 172.16.2.101;
  }

 host hostb {
    hardware ethernet 00:00:00:00:00:00;
    fixed-address 172.16.2.102;
  }

 host hostc {
    hardware ethernet 00:00:00:00:00:00;
    fixed-address 172.16.2.103;
  }
}

EOF

# Configure DHCP server interface
cat << EOF > /etc/default/isc-dhcp-server
INTERFACESv4="enp0s8"
EOF

# Restart DHCP server
systemctl restart isc-dhcp-server
