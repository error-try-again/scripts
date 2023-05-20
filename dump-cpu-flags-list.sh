cat /proc/cpuinfo | grep flags | sed 's/^.*: //' | tr ' ' '\n' | sort | uniq
