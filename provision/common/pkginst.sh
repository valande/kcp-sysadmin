#!/bin/bash
#:
#: pkginst.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Common software provisioning script for VMs
#:

# Import libs
. /vagrant/provision/common/librepo.sh
. /vagrant/provision/common/libsv.sh

# Add elastic-7 repo
[ -f /etc/apt/sources.list.d/elastic-7.x.list ] || add_elastic7_repo

# Install nginx
update_repo_db
install_nginx
start_service "nginx"
enable_service "nginx"
