#!/bin/bash

# Simple rsync backup script

bkp_dir="" #absolute path backup dir
remote_host="" # remote host (IP or FQDN)

rsync -aADXv --delete -e "ssh" --rsync-path="sudo rsync" $remote_host:/ "$bkp_dir"/ --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found,/lib/udev/devices/*,/var/spool/postfix/dev/*}

# Set the last backup date
touch "$dir"
