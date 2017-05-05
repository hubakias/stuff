#!/bin/sh

# Version 0.02
# GPL v2

# Check if the user running the script is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run by root ..." 1>&2
    exit 1
fi

used_swap_partitions="$(tail /proc/swaps -n +2 | awk '$4 != "0" {print $1}')"

# Sync data to disks (just to be safe since we will drop al caches below)
sync

# Drop all caches
echo -n 3>/proc/sys/vm/drop_caches

# Change swappiness???
# echo 5 > /proc/sys/vm/swappiness

# Empty swap partitions (may take some time on slow/heavily_used disks)
if [ "${used_swap_partitions}" ]; then
  for i in "${used_swap_partitions}"; do
    swapoff $i && swapon $i
  done
fi

