#!/bin/bash

# Script to change the Krusader icons

# Check if we are root
if [ $EUID -ne 0 ]; then
  echo 'This script must be run as root ...' 1>&2
  exit 1
fi

# Check if krusader is installed
if [ ! "$(which krusader)" ]; then
  echo 'Install Krusader ...'
  exit 1
fi

# Update the file list
updatedb

# Take a backup of the original file and then copy the intended file
for i in $(locate krusader_blue); do
  if [ ! -f "${i/blue/user.original}" ]; then
    mv -f "${i/blue/user}" "${i/blue/user.original}"
    cp -p "${i}" "${i/blue/user}"
    echo "${i/blue/user}" 'done ...'
  else
    echo "${i/blue/user.original}" 'already exists.'
  fi
done

# Invasive ... but low/no value to make it smarter.
# Cleanup cache and rebuild cache where possible. Advise otherwise.
rm -Rf /home/*/.cache/ksycoca*
rm -Rf /root/.cache/ksycoca5*
kbuildsycoca5 --noincremental
echo 'Run "kbuildsycoca5 --noincremental" as a user.'
