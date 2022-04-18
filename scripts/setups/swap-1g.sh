#!/bin/sh

################################################# EXECUTE THIS! ##############################################################
#                                                                                                                            #
#   sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/swap-1g.sh)"   #
#                                                                                                                            #
##############################################################################################################################

fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

reboot
