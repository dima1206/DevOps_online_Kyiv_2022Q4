#!/bin/bash

yum update -y

# Docker
amazon-linux-extras install -y docker
systemctl enable --now docker
usermod -a -G docker ec2-user

# Docker Compose
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
