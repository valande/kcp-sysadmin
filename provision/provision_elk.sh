#!/bin/bash
#:
#: provision_elk.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Provisioning script for ELK
#:

# Storage definitions & tunning
export partname="extrahd"
export partoffset=2
export partsize="4GB"
export device="/dev/sdc"
export pvname="/dev/sdc1"
export vgname="extra"
export lvname="elasticsearch"
export mountdir="/var/lib/elasticsearch"
export mapper="/dev/mapper/${vgname}-${lvname}"

# Run storage provisioning scripts
bash /vagrant/provision/common/storage.sh

# Run software provisioning scripts
bash /vagrant/provision/common/packages.sh
bash /vagrant/provision/elk/packages.sh
