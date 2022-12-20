#!/bin/bash
#:
#: pkginst.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Common software provisioning script for VMs
#:

# Import libs
. /vagrant/provision/common/librepo.sh

# Add elastic repo
[ -f /etc/apt/sources.list.d/elastic-7.x.list ] || add_elastic_repo

# Install nginx
update_repo_db
install_nginx
