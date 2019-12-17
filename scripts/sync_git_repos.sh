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
if [[ "$@" == *"-f"* ]]; then force="yes" ; fi
if [[ "$@" == *"-r"* ]]; then rebase="true" ; fi

apply () {
  cd "${dir_path}"/"${i}" || echo "${err_dir} ${i}"
  if [ ! "$force" ]; then read -r -n 5 -p $'\nCleanup (yes/no) ? : ' force ; fi
  if [ ! "$rebase" ]; then
    repo="${blue}${bold}$(awk -F "/" '{print $NF}' <<< "$(pwd)")${normal}"
    branch="[$(git branch --no-color 2> /dev/null | awk 'NR==1 {print $NF}')]"
    branch="${yellow}${bold}${branch}${normal}"
    echo
    echo -e "${green}${bold}Pulling: ${repo} ${branch}"
    git pull --all || echo "${err_git}"
  else
    repo="${blue}${bold}$(awk -F "/" '{print $NF}' <<< "$(pwd)")${normal}"
    branch="[$(git branch --no-color 2> /dev/null | awk 'NR==1 {print $NF}')]"
    branch="${yellow}${bold}${branch}${normal}"
    echo
    echo -e "${green}${bold}Rebasing: ${repo} ${branch}"
    git pull --rebase || { echo "${err_git}" ; }
  fi

# Cleanup local stale entries
  if [ "${force,,}" = "yes" ]; then
    echo -e "${green}${bold}Cleaning up:${normal} ${bold}${i}${normal}"
    git remote update --prune origin || echo "${err_git}"
    git fetch -p || echo "${err_git}"
    for i in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
      echo "${red}Warning: ${yellow}${i}${normal} has no remote."
      read -n3 -p "Remove it? (yes/${bold}no${normal}): " del && echo ""
      if [ ! ${del} = "yes" ]; then continue ; fi
      git branch -D ${i} ; unset del
    done
    echo "Doing garbage collection ..." && git gc
  else
    echo -e "\nNothing to do ..."
  fi
}

# Execute
if [ ! "$(find ./ -type d -name '.git' | sed "s/.git$//")" ]; then
  if [ "$(git branch --no-color 2> /dev/null)" ] ;then apply ; fi
else
  for i in $(find ./ -type d -name '.git' | sed "s/.git$//"); do apply ; done
fi

exit 0
