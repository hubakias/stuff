#!/bin/sh

# Install incron
# Add the below line (without leading #) to /etc/incron.d/phabricator_pid_update
# /var/tmp/phd/pid IN_CREATE /usr/local/bin/update_phabricator_pid_file.sh

pgrep -f "php ./phd-daemon" > /var/run/phabricator.pid

exit 0
