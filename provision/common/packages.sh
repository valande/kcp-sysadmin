#!/bin/bash
#:
#: packages.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Common software provisioning script for VMs
#:

# Update repos
apt update -y

# Install nginx
apt install -y nginx
