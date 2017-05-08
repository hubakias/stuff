#!/bin/bash


# Draft ...


# Can be used in any distro that has the "createrepo" package.


# Check if "createrepo exists in the available path"
if [ ! "$(which createrepo)" ]; then
    echo "The package \"createrepo\" is not available in the executable path."
    echo "The packge is probably not installed. Exiting ..."
    exit 1
fi


# Check if we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run by root ..." 1>&2
    exit 1
fi


# Folder which contains all repositories. Also, contains the "all"
# folder which contains packages common to all other repositories.
repo_dir="/srv/yum_repo"


# Repositories
repos="ver_6 ver_7"


# Remove broken symlinks
find $repo_dir -xtype l -exec rm -rf {} \;


# Create symlinks for all the common packages to every repository
for i in $(/bin/ls -d1 $repo_dir/all/*) ; do

    for j in $repos ; do

        ln -s "$i" "$repo_dir"/"$j" 2>/dev/null

    done

done


# Update repositories
for i in $repos ; do

    createrepo --update --basedir "$repo_dir"/"$i" "$repo_dir"/"$i"

done

