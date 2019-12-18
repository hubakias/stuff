#!/bin/sh

# Version 0.01 - Bad hosts
# GPL v2

# Script to gather various hostnames from various locations and generate an
# aggregated list which can be used in bind, squid, /etc/hosts, ...

# Set a random tmp file
tmp_file="/tmp/$(date +%s%N | sha256sum | cut -d ' ' -f1).tmp"

dl_lists="
https://raw.githubusercontent.com/Free-Software-for-Android/AdAway/master/hosts/hosts.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts
http://winhelp2002.mvps.org/hosts.txt
http://www.malwaredomainlist.com/hostslist/hosts.txt
http://someonewhocares.org/hosts/zero/hosts
http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext
"

for i in $dl_lists ; do
    curl -s "$i" >>"$tmp_file"
done

# For use in squid (blocked domains) - look for my squid conf/etc
grep -E "^127.0.0.1 |^0.0.0.0 " "$tmp_file" | sed -e "s/^127.0.0.1 //" -e "s/^0.0.0.0 //" | awk '{print $NF}' | sort | uniq

## For use in /etc/hosts file (either use 127.0.0.1 or 0.0.0.0 - your choice) - I do not recommend it.
#grep -E "^127.0.0.1 |^0.0.0.0 " "$tmp_file" | sed -e "s/^127.0.0.1 //" -e "s/^0.0.0.0 //" | awk '{print $NF}' | sort | uniq  | sed "s/^/127.0.0.1 /"

# Cleanup
rm -f "$tmp_file"


# Add custom entries
#127.0.0.1 dondraper.funda.io
#127.0.0.1 ad.doubleclick.net
