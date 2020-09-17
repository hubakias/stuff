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
output="$(grep "^/dev.* ro[ ,]" /proc/mounts 2>/dev/null | cut -d' ' -f1)"


# Some sanity checks

# Check if the output was properly set.
if [ -n "$output" ] ; then
    echo "Check failed with exit code $?."
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
else
  echo "WARNING - Read only mounted devices were detected."


fi
