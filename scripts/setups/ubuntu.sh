#!/bin/sh

################################################# EXECUTE THIS! #############################################################
#                                                                                                                           #
#   sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/scripts/setups/ubuntu.sh)"   #
#                                                                                                                           #
#############################################################################################################################

apt update
apt upgrade -y

apt install mc htop vim git wget curl net-tools make gcc g++ -y

git config --global user.name "git"
git config --global user.email "git@example.com"

dpkg-reconfigure tzdata

apt update
apt install ntp -y
