#!/bin/bash

# Discover unclaimed/orphan packages

# Packages to ignore. Separated by "|".
ignored_packages="pl@ceholder"

for i in $(dpkg -l | tail -n +6 | cut -d' ' -f3 | grep -E -v "$ignored_packages" ) ; do 
   if [[ -z $(apt-cache madison "$i") ]]; then
     find /tmp/ -mtime 7 -name "check_orphans*" -delete 2>/dev/null
     echo -n "$i " >> /tmp/check_orphans-"$(date "+%d_%b_%G")"
   fi
done

#echo "" >> /tmp/check_orphans-$(date "+%d_%b_%G")

exit 0
