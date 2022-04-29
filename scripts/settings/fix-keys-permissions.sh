#!/bin/sh

################################################# EXECUTE THIS! #############################################################################
#                                                                                                                                           #
#   sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/settings/fix-keys-permissions.sh)"   #
#                                                                                                                                           #
#############################################################################################################################################

chmod 600 -R ~/.ssh
chmod 644 ~/.ssh/known_hosts
chmod 755 ~/.ssh
