#!/bin/bash

# GRNet - Synnefo/Okeanos development team
# Script to automate the process of upgrading Phabricator

# Only root can use the script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

umask 0022

set -e
#set -x

# Start time
start_time="$(date)"

# Set working directory
ROOT="/var/opt"

bkp_date="$(date +%F)"

# Stop daemons - phd and apache
echo "Stopping phd and apache daemons ..."
$ROOT/phabricator/bin/phd stop
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

touch /root/.dbpasswd
if [ /root/.dbpasswd ]; then
    dbpasswd="$(cat /root/.dbpasswd)"
fi

# Backup all databases - needs mysql root user password
echo -e "\nBacking up all databases. Might take a minute or two."
mysqldump -u root -p$dbpasswd --all-databases --events > $ROOT/backup/full_database_backup-"$bkp_date".sql
echo "All databases have been backed up in $ROOT/backup"

### UPDATE WORKING COPIES ######################################################

echo "$bkp_date : Updating phabricator - commit state before the update" > $ROOT/backup/"$bkp_date"_phabricator_pre_update_git_hashes.txt

echo -e "\nUpdating libphutil ..."
sleep 0.2
cd $ROOT/libphutil
echo -n "libphutil : " && git rev-parse HEAD >> $ROOT/backup/"$bkp_date"_phabricator_pre_update_git_hashes.txt
git pull
chmod -R a+rX $ROOT/libphutil
chown -R phab-daemon-user:root $ROOT/libphutil

echo -e "\nUpdating arcanist ..."
sleep 0.2
cd $ROOT/arcanist
echo -n "arcanist : " && git rev-parse HEAD >> $ROOT/backup/"$bkp_date"_phabricator_pre_update_git_hashes.txt
git pull
chmod -R a+rX $ROOT/arcanist
chown -R phab-daemon-user:root $ROOT/arcanist

echo -e "\nUpdating phabricator ..."
sleep 0.2
cd $ROOT/phabricator
echo -n "phabricator : " && git rev-parse HEAD >> $ROOT/backup/"$bkp_date"_phabricator_pre_update_git_hashes.txt
git stash
git pull
chown -R phab-daemon-user:root $ROOT/phabricator
git stash pop
chmod -R a+rX $ROOT/phabricator


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

echo -e '\nUpdate complete!!!\n'

touch /root/.update_bot_api_token
update_bot_api_token="$(cat /root/.update_bot_api_token)"
if [ "$update_bot_api_token" ]; then
    curl https://phab.dev.grnet.gr/api/maniphest.update -d "api.token="$update_bot_api_token"" -d id=66 -d comments="Your faithful update bot: Updated phabricator on $(date +'%A, %d %B %Y, %H:%M:%S')."
else
    echo "Updated phabricator on $(date +'%A, %d %B %Y, %H:%M:%S')."
fi

# End time
end_time="$(date)"

echo -e "\n\e[0;32mStarted on\e[0;37m : $start_time"
echo -e "\e[0;31mEnded on\e[0;37m   : $end_time"

exit 0
