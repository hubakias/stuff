#!/bin/sh

# Version 0.02 - Bad hosts
# GPL v2

# Script to gather various hostnames from various locations and generate an
# aggregated list which can be used in bind, squid, /etc/hosts, ...

# Set a random tmp file
tmp_file="/tmp/hosts_$(date +%s).tmp"

dl_lists_txt="
https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts
https://adaway.org/hosts.txt
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
http://winhelp2002.mvps.org/hosts.txt
http://sysctl.org/cameleon/hosts
https://someonewhocares.org/hosts/zero/hosts
https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt
"

dl_lists_7z="
http://rlwpx.free.fr/WPFF/hblc.7z
http://rlwpx.free.fr/WPFF/htrc.7z
http://rlwpx.free.fr/WPFF/hpub.7z
http://rlwpx.free.fr/WPFF/hrsk.7z
http://rlwpx.free.fr/WPFF/hsex.7z
http://rlwpx.free.fr/WPFF/hmis.7z
"

for i in $dl_lists_txt ; do
    curl -s "$i" >>"$tmp_file" || echo "Error with: $i" >> "$tmp_file".err
done

for i in $dl_lists_7z ; do
    curl -s "$i" --output - | p7zip -d >>"$tmp_file" || echo "Error with: $i" >> "$tmp_file".err
done

# For use in Squid (blocked domains) - look for my squid conf/etc
grep -E "^[0-9]" "$tmp_file" | grep -Ev "^255.255" | awk '{print $2}' | sort | uniq > /tmp/squid.xxx

## For use in /etc/hosts file
#grep -E "^[0-9]" "$tmp_file" | grep -Ev "^255.255" | awk '{print $2}' | sort | uniq | sed "s/^/127.0.0.1       /" > /tmp/hosts.xxx
sed "s/^/127.0.0.1 /" /tmp/squid.xxx > /tmp/hosts.xxx

# Cleanup
#rm -f "$tmp_file"


# Add custom entries
#127.0.0.1 dondraper.funda.io
#127.0.0.1 ad.doubleclick.net
