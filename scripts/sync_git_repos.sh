#!/bin/bash

# Simple script to pull all git repositories under the current path - depth of 1

dir_path="$(pwd)"

for i in $(find ./ -type d -name '.git' | sed "s/.git$//"); do
  if [ -d "$dir_path"/"$i"/.git ]; then
    cd "$dir_path"/"$i"
    git pull -r
  fi
done


