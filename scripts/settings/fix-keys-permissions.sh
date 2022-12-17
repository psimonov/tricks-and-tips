#!/bin/sh

################################################# EXECUTE THIS! ########################################################################
#                                                                                                                                 #
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/settings/fix-keys-permissions.sh)"   #
#                                                                                                                                 #
########################################################################################################################################

sudo chmod 600 -R ~/.ssh
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 755 ~/.ssh
