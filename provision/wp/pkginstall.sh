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
cat << EOF > /etc/nginx/sites-available/wordpress
# Managed by installation script - Do not change
server {
    listen 80;
    root /var/www/wordpress;
    index index.php index.html index.htm index.nginx-debian.html;
    server_name localhost;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/default


# Configure MariaDB
mysql_install_db --datadir=/var/lib/mysql --user=mysql
cat << EOF > /tmp/wordpress.sql
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON wordpress.* TO 'wpuser'@'localhost' IDENTIFIED BY 'valande';
FLUSH PRIVILEGES;
EOF
mysql < /tmp/wordpress.sql
rm /tmp/wordpress.sql


# Install and configure Wordpress
cd /var/www
wget https://wordpress.org/latest.tar.gz
tar xvzf latest.tar.gz && rm latest.tar.gz
chown www-data:www-data /var/www/wordpress
cd /var/www/wordpress
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/wpuser/g' wp-config.php
sed -i 's/password_here/valande/g' wp-config.php


# Install Filebeat and enable system and nginx modules
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt update -y
apt install -y filebeat
filebeat modules enable system
filebeat modules enable nginx


