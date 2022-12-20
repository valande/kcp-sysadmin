#!/bin/bash
#:
#: pkginst.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Software provisioning script for Wordpress VM
#:

# Import libs
. /vagrant/provision/common/libsv.sh
. /vagrant/provision/wp/libwp.sh

# -- Install and configure services
install_mariadb             # MariaDB
install_php                 # PHP deps
configure_nginx             # Nginx config
install_wordpress           # Wordpress
install_filebeat            # Filebeat

# -- Run services
start_services "mariadb" "php7.4-fpm" "filebeat"
enable_services "mariadb" "php7.4-fpm" "filebeat" "nginx"
restart_service "nginx"
