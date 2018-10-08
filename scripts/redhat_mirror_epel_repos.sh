#!/bin/bash

# Draft ...

# Can be used in any distro that has the "createrepo" and "yum-utils" packages.

# Check if "reposync" and "createrepo" exists in the executable path"
for i in createrepo facter reposync; do
  if [ ! "$(which "$i")" ]; then
    echo "You need \"createrepo\", \"facter\" and \"reposync\" packages to proceed."
    exit 1
  fi
done

# Check if we are root
if [ $EUID -ne 0 ]; then
    echo "This script must be run as root ..." 1>&2
    exit 1
fi

# Folder which hosts the repositories
repo_dir="/var/www/html/repo"

# EPEL Repository versions
repos="6 7"

# Set basic variables per distro (Debian or RedHat based)
etcrepo="/etc/yum.repos.d"
etcconf="/etc/yum.conf"
if [ "$(facter -p os.family 2>/dev/null)" = "Debian" ]; then
  etcrepo="/etc/yum/repos.d"
  etcconf="/etc/yum/yum.conf"
fi

#Populate yum repo references.
for i in $repos ; do
  echo "[epel$i]
name=Extra Packages for Enterprise Linux $i - \$basearch
#baseurl=http://download.fedoraproject.org/pub/epel/$i/\$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-$i&arch=\$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-" > ${etcrepo}/epel"$i".repo
done

# Pull the packages and create the indexes (may take some time)
cd $repo_dir || exit 1
for i in $repos ; do
  reposync -l -d -n -c "${etcconf}" -r epel"$i"
  createrepo --update --basedir epel"$i" "$(pwd)"/epel"$i"
done

exit 0
