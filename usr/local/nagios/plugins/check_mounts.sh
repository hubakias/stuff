#!/bin/bash
#
# License GPL v2 <http://www.gnu.org/licenses/>
#
# Nagios plugin / shell script to check mounts
#
# WIP: Initial will check if a /dev/* dev is mounted as ro or no.
# Ideally it should be a wildcard plugin being able to be configurable to
# perform any kind of check (mount related).

# Get the minimum necessary information.
max_devs="$(grep ^dev /proc/mounts 2>/dev/null)"
output="$(grep "^dev.*\sro[\s,]" /proc/mounts 2>/dev/null)"

# Some sanity checks

# Check if the output was properly set.
if [ $? -ne 0 ] ; then
    echo "Check failed with exit code $?"
    exit 3
fi

# Check that the wanted devices were detected.
if [ -z "$max_devs" ] ; then
    echo "Something went wrong. Requested devices to check were not found."
    exit 3
fi

# Check that the numbers of max and ro devices make sense.
num_output="$(wc -l <<< "$output")"
num_max_devs="$(wc -l <<< "$max_devs")"
if [ "$num_output" -gt "$num_max_devs" ] ; then
    echo "Something went wrong. Please check ..."
    exit 3
fi


# Status codes

# No read only devices were detected.
if [ -z "$output" ] ; then
    timeout 1s touch /tmp 2>/dev/null
    if [ "$?" -ne 0 ]; then
      echo "Critical - Root partition is not accessible."
    fi
    echo "OK - No read only partitions on block devices found."
    exit 0
fi

# All devices are mounted read only.
if [ "$num_output" -eq "$num_max_devs" ] ; then
    echo "Critical - All devices are mounted read only."
    exit 2
fi

# A few, not all, devices are mounted read only.
if [ "$num_output" -lt "$num_max_devs" ] ; then
    check_root="$(grep "rootfs.*\sro[\s,]" /proc/mounts 2>/dev/null)"
    if [ -z "$check_root" ]; then
      echo "WARNING - Some devices are mounted read only."
      exit 1
    fi
    echo "Critical - Root partition is mounted read only."
    exit 2
fi

