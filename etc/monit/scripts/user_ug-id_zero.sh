#!/bin/sh

#
# Simple script to check:
#   if there are accounts, besides root, that have UID = 0
#
# Monit daemon needs to be able to execute the script (set the executable bit)
#

# Check if we can read the file.
if [ ! -r /etc/passwd ]; then exit 1 ; fi

# Check if there are user accounts with UID = 0 , besides root.
prob="$(awk -F: '($3 == "0" && $1 != "root") {print}' /etc/passwd)"
if [ $prob ]; then exit 2 ; fi

