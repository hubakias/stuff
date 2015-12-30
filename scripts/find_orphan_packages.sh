#!/bin/bash

# Released under the GPL v2
# Last update December 2015

# For Debian based distros
# Discover unclaimed/orphan packages (those that do not belond to any repo).
# Check against every installed package in the system (as provided by dpkg) and
# verify it is referenced to at least one repository package file.

# Let's hope that all Debian based distros maintain this file
if [ ! -f "/etc/debian_version" ]; then
    echo "This script is for Debian based distros."
    exit 1
fi

# Check if the required commands are available
if [ $(which dpkg) ] && [ $(which apt-cache) ]; then
    echo "Starting ..."
else
    echo "Required packages are missing."
    exit 1
fi

# Packages to ignore. Separated by "|".
ignored_packages="pl@ceholder"

for i in $(dpkg -l | tail -n +6 | cut -d' ' -f3 | egrep -v "$ignored_packages" ) ; do 
   if [[ -z $(apt-cache madison $i) ]]; then
     find /tmp/ -mtime 7 -name check_orphans* -delete 2>/dev/null
     echo -n "$i " >> /tmp/check_orphans-$(date "+%d_%b_%G")
   fi
done

echo "" >> /tmp/check_orphans-$(date "+%d_%b_%G")

exit 0
