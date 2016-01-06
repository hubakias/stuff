#!/bin/sh

# Simple script to check the cpu temperature - intended to be used by monit
# Can check anything else similar.
# Monit daemon needs to be able to execute the script (set the executable bit)

# Depends on lm_sensors - install the package and configure it accordingly

# Specify what you want to check - eg the nth cpu
checked_item="^Core 3"


if [ $(which sensors) ]; then
    exit $(sensors | grep "$checked_item" | sed "s/\..°.*//" | sed "s/.*+//")
else
    exit 250
fi
