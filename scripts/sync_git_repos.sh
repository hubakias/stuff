#!/bin/bash

# Simple script to pull all git repositories under the current path

# Hide STDERR
exec 2>/dev/null

# use script library
. "$(dirname "$0")"/script_lib

# Define variables
dir_path="$(pwd)"

# Set error messages
err_dir="${red}Could not change into directory:${normal}"
err_git="${red}Failed to pull repository!${normal}"

# Execute
for i in $(find ./ -type d -name '.git' | sed "s/.git$//"); do

  cd "${dir_path}"/"${i}" || { echo "${err_dir} ${i}" ; continue ; }
  echo -e "\n${green}Pulling:${normal} ${bold}${i}${normal}"
  git pull --all || { echo "${err_git}" ; continue ; }
#  git pull --rebase || { echo "${err_git}" ; continue ; }

done

echo

exit 0
