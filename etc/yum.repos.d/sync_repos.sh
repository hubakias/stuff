#!/bin/bash
#
# "Clone" RH* repositories
#
# Install yum and yum-utils

export etcrepo='/etc/yum/repos.d'

l_dir="/srv/repo" # Variable for the local repository directory
if [ ! "${l_dir}" ] ; then echo "Set the repository dir"; exit 1 ; fi

etcconf='/etc/yum/yum.conf'

centos6="centos6 centos6_extras epel6"
centos7="centos7 centos7_extras epel7"
centos8="centos8_base_os centos8_powertools centos8_extras epel8"
docker="docker_centos7_ce_stable"

for i in ${centos6} ${centos7} ${centos8} ${docker}; do
      cd "${l_dir}" || (echo "Cannot find repo dir" && exit 1)
      reposync -l -d -n -c "${etcconf}" -r "$i"
done | grep -v "Skipping existing Packages"

#mount -o loop "${l_dir}"/rhel-server-6.10-x86_64-dvd.iso "${l_dir}"/rhel6
#mount -o loop "${l_dir}"/rhel-server-7.9-x86_64-dvd.iso "${l_dir}"/rhel7
#mount -o loop "${l_dir}"/rhel-8.2-x86_64-dvd.iso "${l_dir}"/rhel8/
