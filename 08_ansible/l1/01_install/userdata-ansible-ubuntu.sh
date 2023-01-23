#!/bin/sh

apt update
apt upgrade -y

apt install -y python3-pip
sudo -u ubuntu python3 -m pip install --user ansible

sudo -u ubuntu echo "Ansible is installed, relogin if needed" > /home/ubuntu/installed.txt
