#!/bin/bash
#:
#: librepos.sh  [ valande@gmail.com ]
#:

update_repo_db()
{
    apt-get update -y
}

add_elastic7_repo()
{
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
    apt-get install apt-transport-https
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
    update_repo_db
}

install_nginx()
{
    apt-get install -y nginx
}

