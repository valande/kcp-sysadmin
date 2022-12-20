#!/bin/bash
#:
#: pkginstall.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Common software provisioning script for VMs
#:

# Update repos
apt update -y

# Install nginx
apt install -y nginx

# Add and enable elastic.co packages repository
if [ ! -f /etc/apt/sources.list.d/elastic-8.x.list ]; then
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
    apt-get install apt-transport-https
    echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-8.x.list
    apt update -y
fi
