#!/bin/bash
#:
#: provision_elk.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Provisioning script for ELK stack VM "kc-elk"
#:

# Storage provisioning vars
export partname="extrahd"
export partoffset=2
export partsize="4GB"
export device="/dev/sdc"
export pvname="/dev/sdc1"
export vgname="extra"
export lvname="elasticsearch"
export mountdir="/var/lib/elasticsearch"
export mapper="/dev/mapper/${vgname}-${lvname}"

# Storage provisioning script
bash /vagrant/provision/common/storage.sh
