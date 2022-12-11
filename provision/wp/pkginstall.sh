#!/bin/bash
#:
#: pkginstall.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Software provisioning script for Wordpress VM
#:

# Install and secure MariaDB database
apt install -y mariadb-server

# Install PHP dependencies
apt install -y php-fpm php-mysql expect php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip


# Configure nginx
