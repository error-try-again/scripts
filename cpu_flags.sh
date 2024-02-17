#!/bin/bash

# Sorts unique CPU flags then redirects the output to cpu-capability.txt
cat /proc/cpuinfo | grep flags | sed 's/^.*: //' | tr ' ' '\n' | sort | uniq > cpu-capability.txt
