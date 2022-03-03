#!/bin/bash

# update the system
apt update && apt upgrade -y

# install docker
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update && apt-get install docker-ce docker-ce-cli containerd.io -y

# configure docker
groupadd docker

usermod -aG docker azureadmin

mkdir /home/azureadmin/.docker

chown azureadmin:azureadmin /home/azureadmin/.docker -R
chmod g+rwx /home/azureadmin/.docker -R