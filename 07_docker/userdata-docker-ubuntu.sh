#!/bin/sh

apt update
apt upgrade -y

# docker GPG key
apt install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# docker repo
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
	https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# configure the user to have access to docker without SU privileges
usermod -a -G docker ubuntu
