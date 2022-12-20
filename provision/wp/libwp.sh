#!/bin/bash
#:
#: libwp.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Service provisioning function library
#:

install_mariadb()
{
apt-get install -y mariadb-server
mysql_install_db --datadir=/var/lib/mysql --user=mysql

mysql --user=root << _EOF_
UPDATE mysql.user SET Password=PASSWORD('keepcodingRoot') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON wordpress.* TO 'wpuser'@'localhost' IDENTIFIED BY 'keepcodingWP';
FLUSH PRIVILEGES;
_EOF_
}


install_php()
{
apt-get install -y php-fpm php-mysql expect php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
}


install_wordpress()
{
wget https://wordpress.org/latest.tar.gz -O /var/www/latest.tar.gz
tar -C /var/www -xvzf /var/www/latest.tar.gz
chown www-data:www-data /var/www/wordpress
rm /var/www/latest.tar.gz
cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
chown nobody:nogroup /var/www/wordpress/wp-config.php
sed -i 's/database_name_here/wordpress/g' /var/www/wordpress/wp-config.php
sed -i 's/username_here/wpuser/g' /var/www/wordpress/wp-config.php
sed -i 's/password_here/keepcodingWP/g' /var/www/wordpress/wp-config.php
}


install_filebeat()
{
apt-get install -y filebeat
filebeat modules enable system
filebeat modules enable nginx
rm -f /etc/filebeat/filebeat.yml
cp /vagrant/templates/filebeat.yml /etc/filebeat/filebeat.yml
chmod 600 /etc/filebeat/filebeat.yml
systemctl enable filebeat --now
}


configure_nginx()
{
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
}
