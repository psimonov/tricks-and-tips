#!/bin/sh

################################################# EXECUTE THIS! #############################################################
#                                                                                                                           #
#   sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/psimonov/tricks-and-tips/master/settings/setup-docker.sh)"   #
#                                                                                                                           #
#############################################################################################################################

apt remove docker docker-engine docker.io containerd runc

apt update

apt install ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install docker-ce docker-ce-cli containerd.io -y

sudo groupadd docker

sudo usermod -aG docker "$USER"

newgrp docker

systemctl enable docker.service
systemctl enable containerd.service

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker -v
docker-compose -v
