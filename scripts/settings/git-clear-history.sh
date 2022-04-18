#!/bin/sh

################################################# EXECUTE THIS! ##########################################################################
#                                                                                                                                        #
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/settings/git-clear-history.sh)"        #
#                                                                                                                                        #
##########################################################################################################################################

# Create new branch
git checkout --orphan latest_branch

# Add all files
git add -A

# Commit
git commit -am ...

# Remove master
git branch -D master

# Rename new branch to master
git branch -m master

# Force push
git push -f origin master
