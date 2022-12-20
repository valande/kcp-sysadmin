#!/bin/bash
#:
#: pkginstall.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Software provisioning script for Wordpress VM
#:

# Some vars
dbname=wordpress
dbuser=wpuser
dbpass=valande
dbrootpass=keepcoding

# Install MariaDB
apt-get install -y mariadb-server

if [ ! -f /var/lib/mysql/.dbinstok ]; then

mysql_install_db --datadir=/var/lib/mysql --user=mysql

# Protect MariaDB Installation
myql --user=root << EOF
UPDATE mysql.user SET Password=PASSWORD('${dbrootpass}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Create Wordpress database
cat << EOF > /tmp/wordpress.sql
CREATE DATABASE ${dbname} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON ${dbname}.* TO '${dbuser}'@'localhost' IDENTIFIED BY '${dbpass}';
FLUSH PRIVILEGES;
EOF
mysql < /tmp/wordpress.sql
rm /tmp/wordpress.sql

touch /var/lib/mysql/.mdbinstok

fi

# Install PHP dependencies
apt-get install -y php-fpm php-mysql expect php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

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


# Install and configure Wordpress
if [ ! -d /var/www/wordpress ]; then
    cd /var/www
    wget https://wordpress.org/latest.tar.gz
    tar xvzf latest.tar.gz && rm latest.tar.gz
    chown www-data:www-data /var/www/wordpress
    cd /var/www/wordpress
    cp wp-config-sample.php wp-config.php
    sed -i 's/database_name_here/${dbname}/g' wp-config.php
    sed -i 's/username_here/${dbuser}/g' wp-config.php
    sed -i 's/password_here/${dbpass}/g' wp-config.php
fi


# Install Filebeat and enable system and nginx modules
apt-get install -y filebeat
filebeat modules enable system
filebeat modules enable nginx

# TODO: Edit filebeat config on /etc/filebeat/filebeat.yml

# Run services
systemctl enable filebeat --now
systemctl restart nginx
