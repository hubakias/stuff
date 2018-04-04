#!/bin/bash
#
# List malicious sites (domain) - check below
#
# 2017-2018 kostikas
#
# Released under the GPL v3
#
# Meant to be used for the /etc/hosts file and/or Squid.
#

# Check if ssconvert exists (gnumeric) - needed to convert and parse files
if [ -z "$(which ssconvert)" ]; then
  echo "This package needs ssconvert."
  echo "Please install package gnumeric which contains it."
  exit 1
fi

tmp_file="/tmp/kt_${RANDOM}.tmp"


####################################
###   Gaming commission gov gr   ###
####################################

# The url to get the information from
url="https://www.gamingcommission.gov.gr/images/epopteia-kai-elegxos/blacklist/blacklist.xlsx"

# Get the data
curl --connect-timeout 3 -m 10 -s -o "$tmp_file" $url

# Convert the data to a more "parsable" format
#libreoffice --headless --convert-to csv "$tmp_file"
ssconvert "$tmp_file" "$tmp_file".csv 2>/dev/null

# Parse the content of the file (above) and provide an easire to use file.
egrep "^[1-9]" "$tmp_file".csv | egrep "," | cut -d ',' -f3 | \
cut -d '/' -f1 | egrep "\." | sed "s/^/127.0.0.1 /" > "$tmp_file".gc




############################################
###   http://www.malwaredomainlist.com   ###
############################################

# The url to get the information from
url="http://www.malwaredomainlist.com/mdlcsv.php"

# Get the data
curl --connect-timeout 3 -m 10 -s -o "$tmp_file" $url

# Parse the content of the file (above) and provide an easier to use file.
cut -d '"' -f4,6 "$tmp_file" | grep ^- | sed "s/^..//" | cut -d "/" -f1 | \
cut -d ":" -f1 | sort | uniq > "/tmp/$(date +%F)_bad_IPs"
cut -d '"' -f4,6 "$tmp_file" | grep -v ^- | sed "s/\/.*//" | cut -d '"' -f1 | \
grep -v ^$ | sort | uniq | sed "s/^/127.0.0.1 /" > "$tmp_file".dom.md # domains

# Cleanup/Remove unneeded files
rm -f "$tmp_file"
rm -f "$tmp_file".csv

# Concatenate the files that contain domain names only
cat "$tmp_file".[gd]* | sort | uniq > "/tmp/$(date +%F)_bad_domains"

# Results
#echo -e "\nOutput file of Gaming commission gov gr : ""$tmp_file"".gc"
echo -e "\nMalware IP list : ""$(wc -l /tmp/$(date +%F)_bad_IPs)"
#echo -e "\nOutput file of Malware Domain list (Domains): ""$tmp_file"".dom.md"
echo -e "\nMalware Domain list : ""$(wc -l /tmp/$(date +%F)_bad_domains)\n"

# Compare with /etc/hosts and report
# diff -u /etc/hosts /tmp/2018-04-03_bad_domains | \
# sed "s/^-127.0.0.1/Removed:/p" | sed "s/^+127.0.0.1/Added:/" | \
# egrep "^Add|^Rem" | sort

# Regenerate /etc/hosts file
# cat /etc/hosts.base /tmp/$(date +%F)_bad_domains > /etc/hosts

# Add reported IPs to the firewall
# for i in $(cat /tmp/$(date +%F)_bad_IPs) ; do
#   iptables -I INPUT -s $i -j DROP
# done



exit 0
