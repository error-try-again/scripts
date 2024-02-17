#!/bin/bash

# Dumps kernel TCP/UDP params to two lists and counts the number of each list by word count
echo -e "$(cat /proc/sys/net/ipv4/tcp*|wc -w) tcp\n$(cat /proc/sys/net/ipv4/udp*|wc -w) udp" > tcpudp-count.txt
