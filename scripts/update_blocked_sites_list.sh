#!/bin/bash
#
# Released under the GPL v2
# Last update May 2017
#
# Gather "malicious" site list
# Meant to be used for the /etc/hosts file and/or Squid.
#
# Notes : At the moment the whole domain is considered "malicious"
# Notes : Not specific paths.
#

# Check if ssconvert exists - needed to convert and parse files
if [ -z "$(which ssconvert)" ]; then
  echo "This package needs ssconvert."
  echo "Please install package gnumeric which contains it."
  exit 1
fi

# A random hash to use for storing the temporary files (in /tmp - volatile)
#tmp_file="/tmp/$(date +%s%N | sha256sum | cut -d ' ' -f1).tmp" # too long
tmp_file="/tmp/$(date +%s%N | md5sum | cut -d ' ' -f1).tmp"


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
cut -d ":" -f1 | sort | uniq > "$tmp_file".ips.md # IPs only
cut -d '"' -f4,6 "$tmp_file" | grep -v ^- | sed "s/\/.*//" | cut -d '"' -f1 | \
grep -v ^$ | sort | uniq | sed "s/^/127.0.0.1 /" > "$tmp_file".dom.md # domains

# Cleanup/Remove unneeded files
rm -f "$tmp_file"
rm -f "$tmp_file".csv

# Concatenate the files that contain domain names only
cat "$tmp_file".gc "$tmp_file".dom.md | sort | uniq > "$tmp_file".hosts

# Results
echo -e "\nOutput file of Gaming commission gov gr : ""$tmp_file"".gc\n"
echo -e "Output file of Malware Domain list (IPs): ""$tmp_file"".ips.md\n"
echo -e "Output file of Malware Domain list (Domains): ""$tmp_file"".dom.md\n"
echo -e "Merged file of all domain based output : ""$tmp_file"".hosts\n"

exit 0
