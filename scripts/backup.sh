#!/bin/bash

# Simple rsync backup script

# Remote how (IP or FQDN)
remote_host="$1"

# Backup directory - currently the location of the script
bkp_dir="$(dirname "$0")/${remote_host}"

touch "$(dirname "$0")"/exclusions_"${remote_host}"

rsync -aADXhvz --delete --delete-excluded -e "ssh" --rsync-path="sudo rsync" \
  "${remote_host}":/ "${bkp_dir}" --exclude-from "./exclusions_${remote_host}"

# Set the last backup date
touch "${bkp_dir}"

# The exclusion list for a host usually include :
#{/dev,/lib/udev/devices,/lost+found,/media,/mnt,/proc,/run,/sys,/tmp, \
#  /var/spool,/var/cache}

# For "sudo rsync" to work, add to the host(s) in a/the sudoers file :
# "username ALL = NOPASSWD: /usr/bin/rsync ...$args"
# Change the username accordingly.
# Do not forget to add the precise arguments. Avoid using wildcards.

exit 0
