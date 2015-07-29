#!/bin/bash

# Last update on 29 of July 2015
# Script to automate the process of upgrading Phabricator.
# Databases are backed up before the upgrade process starts.

# Only root can use the script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

set -e
#set -x

# Set working directory - Path where phabricator,arcanist,libphutil repos are
ROOT="/var/opt"

bkp_date="$(date +%F)"

# Stop daemons - phd and apache
echo "Stopping phd and apache daemons ..."
umask 022 && su phab-daemon-user -c "$ROOT/phabricator/bin/phd stop"
sleep 2
if [ -n "$(pgrep php)" ] ; then
     echo "Cannot stop phabricator daemons."
     echo "Exiting ..."
     exit 1
fi

echo "Stopping Phabricator daemons. Done!"

/etc/init.d/apache2 stop # Overkill - just to be safe
sleep 0.2
echo "Stopping Apache daemon. Done!"

# If running the notification server, stop it.
# $ROOT/phabricator/bin/aphlict stop

# Backup all databases - needs mysql root user password
echo -e "\nBacking up all databases. Might take a minute or two."
echo "Provide the database password : "
read db_passwd
echo "Please be patient ..."
mysqldump -u root -p $db_passwd --all-databases --events > $ROOT/full_database_backup-"$bkp_date".sql
echo "All databases have been backed up in $ROOT"

### UPDATE WORKING COPIES ######################################################

echo "$bkp_date : Updating phabricator - commit state before the update" > $ROOT/"$bkp_date"_phabricator_pre_update_git_hashes.txt

echo -e "\nUpdating libphutil ..."
sleep 0.2
cd $ROOT/libphutil
echo -n "libphutil : " && git rev-parse HEAD >> $ROOT/"$bkp_date"_phabricator_pre_update_git_hashes.txt
git pull

echo -e "\nUpdating arcanist ..."
sleep 0.2
cd $ROOT/arcanist
echo -n "arcanist : " && git rev-parse HEAD >> $ROOT/"$bkp_date"_phabricator_pre_update_git_hashes.txt
git pull

echo -e"\nUpdating phabricator ..."
sleep 0.2
cd $ROOT/phabricator
echo -n "phabricator : " && git rev-parse HEAD >> $ROOT/"$bkp_date"_phabricator_pre_update_git_hashes.txt
git pull


echo -e "\nUpgrading the database schema ..."
# Upgrade the database schema. You may want to add the "--force" flag to allow
# this script to run noninteractively.
$ROOT/phabricator/bin/storage --force upgrade
echo "Done!"

sleep 1

# Restart the webserver. As above, this depends on your system and webserver.
# NOTE: If you're running php-fpm, restart it here too.
echo "Starting Apache ... "
/etc/init.d/apache2 start
echo "Done!"

# Restart daemons.
echo "Starting phd ... "
$ROOT/phabricator/bin/phd start
echo "Done!"

# If running the notification server, start it.
# $ROOT/phabricator/bin/aphlict start

echo -e "\nUpdate complete!!!\n"

# You may add a comment once the update is complete.
# Uncomment the line below, set the phabricator_host, api.token and task id.
#curl https://$phabricator_host/api/maniphest.update -d "api.token=$api_token" -d id=$task_id -d comments="Your faithful update bot: Updated phabricator on $(date +'%A, %d %B %Y, %H:%M:%S')."

exit 0
