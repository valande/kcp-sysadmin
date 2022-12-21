#!/bin/bash
#:
#: libelk.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Service provisioning function library
#:

install_jre()
{
apt-get install -y default-jre
}


install_logstash()
{
apt-get install -y logstash
cp /vagrant/templates/*.conf /etc/logstash/conf.d/
chmod 644 /etc/logstash/conf.d/*.conf
}


install_elasticsearch()
{
apt-get install -y elasticsearch
chown elasticsearch:elasticsearch /var/lib/elasticsearch
}


install_kibana()
{
apt-get install -y kibana 
cp /vagrant/templates/kibana-nginx-site /etc/nginx/sites-available/default

# Basic auth for kibana
touch /etc/nginx/htpasswd.users
if ! grep -q kibanaadmin /etc/nginx/htpasswd.users; then
    echo "kibanaadmin:$(openssl passwd -apr1 -in /vagrant/.kibana)" >> /etc/nginx/htpasswd.users
fi
}
