#!/bin/bash

# Simple script to pull all git repositories under the current path

# Hide STDERR
#exec 2>/dev/null

# use script library
. "$(dirname "$0")"/script_lib

# Define variables
dir_path="$(pwd)"

# Set error messages
err_dir="${red}Could not change into directory:${normal}"
err_git="${red}Failed to pull repository!${normal}"

if [ "$1" = "-f" ]; then

  ee="p"
  eee="yes"

fi


# Execute
for i in $(find ./ -type d -name '.git' | sed "s/.git$//"); do

  cd "${dir_path}"/"${i}" || { echo "${err_dir} ${i}" ; continue ; }

  if [ ! "$ee" ]; then read -r -n1 -p "Rebase/Pull (r/p)?" ee ; fi

  if [ "${ee,,}" = "p" ]; then

    echo -e "\n${green}Pulling:${normal} ${bold}${i}${normal}"
    git pull --all || { echo "${err_git}" ; continue ; }

  elif [ "${ee,,}" = "r" ]; then

    echo -e "\n${green}Rebasing:${normal} ${bold}${i}${normal}"
    git pull --rebase || { echo "${err_git}" ; continue ; }

  else

    echo "Moving on ..."

  fi

# Cleanup local stale entries
  if [ ! "$eee" ]; then read -r -n 5 -p "Cleanup ??? (yes/no)" eee ; fi

  if [ "${eee,,}" = "yes" ]; then

    echo -e "\n${green}Cleaning up:${normal} ${bold}${i}${normal}"
    git remote update --prune origin || { echo "${err_git}" ; continue ; }

  else

    echo -e "\nNothing to do ..."

  fi

done

echo

exit 0
