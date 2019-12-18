#!/bin/bash

git filter-branch --env-filter '
WRONG_EMAIL=""
NEW_NAME=""
NEW_EMAIL=""
if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

# git push --force --tags origin 'refs/heads/*' # Force push changes
# git update-ref -d refs/original/refs/heads/master # Remove git backup
