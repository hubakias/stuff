#!/bin/bash

# Dosage is used to download Comics (e.g. xkcd)

if [ ! "$(which dosage)"  ]; then
    echo "This script needs package dosage."
    exit 1
fi

# Use help to find out more
dosage --adult -o html -c xkcd

exit 0
