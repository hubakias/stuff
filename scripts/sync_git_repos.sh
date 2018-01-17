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

# Dirty way to check if the below options are supplied in the command line.
if [[ "$@" == *"-f"* ]]; then
  if [[ "$@" == *"-r"* ]]; then
    ee="r"
  else
    ee="p"
  fi
  eee="yes"
fi

# Execute
for i in $(find ./ -type d -name '.git' | sed "s/.git$//"); do
  cd "${dir_path}"/"${i}" || { echo "${err_dir} ${i}" ; continue ; }
  if [ ! "$ee" ]; then read -r -s -n1 -p $'\nRebase/Pull (r/p)? : ' ee ; fi
  if [ ! "$eee" ]; then read -r -n 5 -p $'\nCleanup (yes/no) ? : ' eee ; fi
  if [ "${ee,,}" = "p" ]; then
    repo="${blue}${bold}$(awk -F "/" '{print $NF}' <<< "$(pwd)")${normal}"
    branch="[$(git branch --no-color 2> /dev/null | awk 'NR==1 {print $NF}')]"
    branch="${yellow}${bold}${branch}${normal}"
    echo
#    echo -e "${bold}Directory:${normal} ${blue}${bold}${i}${normal}"
    echo -e "${green}${bold}Pulling: ${repo} ${branch}"
    git pull --all || { echo "${err_git}" ; continue ; }
  elif [ "${ee,,}" = "r" ]; then
    repo="${blue}${bold}$(awk -F "/" '{print $NF}' <<< "$(pwd)")${normal}"
    branch="[$(git branch --no-color 2> /dev/null | awk 'NR==1 {print $NF}')]"
    branch="${yellow}${bold}${branch}${normal}"
    echo
#    echo -e "\n${bold}Directory:${normal} ${blue}${bold}${i}${normal}"
    echo -e "${green}${bold}Rebasing: ${repo} ${branch}"
    git pull --rebase || { echo "${err_git}" ; continue ; }
  else
    echo "Moving on ..."
  fi

# Cleanup local stale entries
  if [ "${eee,,}" = "yes" ]; then
    echo -e "${green}${bold}Cleaning up:${normal} ${bold}${i}${normal}"
    git remote update --prune origin || { echo "${err_git}" ; continue ; }
    git fetch -p || { echo "${err_git}" ; continue ; }
    for i in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
      echo "${red}Warning: ${yellow}${i}${normal} has no remote."
      read -n3 -p "Remove it? (yes/${bold}no${normal})" del
      if [ ! ${del} = "yes" ]; then continue ; fi
      git branch -D ${i}
    done
  else
    echo -e "\nNothing to do ..."
  fi
done
echo
exit 0
