#!/bin/bash
#
# Released under the GPL v2
# Last update April 2017
#
# Gather "malicious" site list
# Meant to be used for the /etc/hosts file and/or Squid.
#
# Notes : At the moment the whole domain is considered "malicious"
# Notes : Not specific paths.
#

if [ -z "$(which ssconvert)" ]; then
  echo "This package needs ssconvert."
  echo "Please install package gnumeric which contains it."
  exit 1
fi

tmp_file="/tmp/$(date +%s%N | sha256sum | cut -d ' ' -f1).tmp"

####################################
###   Gaming commission gov gr   ###
####################################
url="https://www.gamingcommission.gov.gr/images/epopteia-kai-elegxos/blacklist/blacklist.xlsx"
curl --connect-timeout 3 -m 10 -s -o "$tmp_file" $url
#libreoffice --headless --convert-to csv "$tmp_file"
ssconvert "$tmp_file" "$tmp_file".csv 2>/dev/null
egrep "^[1-9]" "$tmp_file".csv | egrep "," | cut -d ',' -f3 | cut -d '/' -f1 | egrep "\." | sed "s/^/127.0.0.1 /" > "$tmp_file".a
rm -f "$tmp_file".csv

############################################
###   http://www.malwaredomainlist.com   ###
############################################
url="http://www.malwaredomainlist.com/mdlcsv.php"
curl --connect-timeout 3 -m 10 -s -o "$tmp_file" $url
cut -d '"' -f4,6 "$tmp_file" | grep ^- | sed "s/^..//" | cut -d "/" -f1 | cut -d ":" -f1 | sort | uniq > "$tmp_file".b # IPs only
cut -d '"' -f4,6 "$tmp_file" | grep -v ^- | sed "s/\/.*//" | cut -d '"' -f1 | grep -v ^$ | sort | uniq | sed "s/^/127.0.0.1 /" > "$tmp_file".c # domains only
rm -f "$tmp_file"

exit 0
