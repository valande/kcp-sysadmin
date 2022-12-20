#!/bin/bash
#:
#: pkginst.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Software provisioning script for ELK VM
#:

# -- Import libs
. /vagrant/provision/common/libsv.sh
. /vagrant/provision/elk/libelk.sh

# -- Install and configure services
install_jre                     # Java dependencies
install_logstash                # Logstash
install_elasticsearch           # Elasticsearch
install_kibana                  # Kibana

# -- Run services
systemctl daemon-reload             
enable_services logstash elasticsearch kibana nginx
restart_service nginx
