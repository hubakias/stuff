#!/bin/bash

# Simple script to clean repos, user histories, tmp files and defrag the disks.

yum clean all
rm -Rf /var/lib/yum/yumdb /var/lib/yum /var/cache/yum/ /tmp/.* /tmp/*
rm -Rf /home/*/.*history /home/*/.ssh/known_hosts
rm -Rf /root/.*history /root/.ssh/known_hosts /var/lib/mlocate/mlocate.db
rm -Rf /var/log/lost+found /var/log/anaco* # /root/*
for i in $(find /var/log/ -type f); do echo -n >$i ; done

for i in $(cat /proc/mounts | grep ^/dev | cut -d' ' -f2); do
  dd if=/dev/zero of="${i}"/aaaa bs=4M
done

for i in $(cat /proc/mounts | grep ^/dev | cut -d' ' -f2); do
  rm -Rf "${i}"/aaaa
done
df
history -c

exit 0
