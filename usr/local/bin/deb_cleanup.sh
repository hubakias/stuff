#!/bin/sh

# Version 0.02
# GPL v2

# Meant to be used on Debian hosts.
# Should keep the system fairly clean from apt/dpkg controlled packages.

# Usage:
# Run the script as root - input will be needed if/when a commands demands it.
# No force flags are implemented. The script should run interactively.
# Check the friendly manual of each command for details.

# For thorough understating of the actions you should the man of each command.


# Check if the user running the script is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run by root ..." 1>&2
    exit 1
fi

# Check if aptitude is installed - if not ignore and proceed
if [ "$(which aptitude)" ]; then
    aptitude purge '~c'
fi

# Completely remove packages that are no longer needed (as dependencies)
apt-get --purge autoremove

# Check recursively if there are any orphans ( packages that were not explicitly
# installed and that no other package depends on them ).
while [ "$(deborphan -n | wc -l)" -gt 0 ] ; do
    apt-get purge "$(deborphan -n)"
done

# Erase the existing information about what packages are available.
dpkg --clear-avail

# Repopulate the the information cleared above from the system repositories.
apt-get update

# Remove downloaded deb packages from cache - clear cache
apt-get clean

# Carefully check the output of the below
# dpkg --no-act --purge *

# Maybe get rid of unnecessary stuff - especially in simple servers
#dpkg -l | egrep -i "smb|samba|avahi|sound|media|video|cups|heimdal"
#dpkg -l | egrep -iv "^ii" # show packages not properly installed
#dpkg -l | egrep "^rc" | awk '{print $2}' | tr '\n' ' ' # show remainders

exit 0
