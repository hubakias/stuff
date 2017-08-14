#!/bin/sh

#
# Simple script to check:
#   if there are accounts without passwords
#
# Monit daemon needs to be able to execute the script (set the executable bit)
#

# Check if we can read the file.
if [ ! -r /etc/shadow ]; then exit 1 ; fi

# Check if there are user accounts without anything set in the password field.
if [ ! "$(awk -F: '($2 == "") {print}' /etc/shadow)" ]; then exit 2 ; fi

