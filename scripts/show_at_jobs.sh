#!/bin/bash

# Script to show the existing at jobs of the user invoking the script.

tmp_file="/var/tmp/$(whoami)_at_jobs" # File to hold the information.

for i in $(atq | awk '{print $1}') ; do

  echo -e "Job: $(atq | grep ^"$i")"
  at -c "$i" | tail -n 2

done > "${tmp_file}"

