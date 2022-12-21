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
mysql --user=root < /vagrant/templates/mariadb.sql
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
cp /vagrant/templates/wordpress-nginx-site /etc/nginx/sites-available/wordpress
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/default
}
