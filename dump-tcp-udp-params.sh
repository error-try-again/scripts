#!/bin/bash

echo -e "$(cat /proc/sys/net/ipv4/tcp*|wc -w) tcp\n$(cat /proc/sys/net/ipv4/udp*|wc -w) udp"
