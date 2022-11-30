#!/bin/bash

# update packages and install Java
yum update -y
amazon-linux-extras install -y java-openjdk11

# install latest Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
yum install -y jenkins
systemctl enable --now jenkins

# make a script to get initial password easier
echo 'cat /var/lib/jenkins/secrets/initialAdminPassword' > /home/ec2-user/initialPasswd.sh
chown ec2-user.ec2-user /home/ec2-user/initialPasswd.sh
chmod u+x /home/ec2-user/initialPasswd.sh
