#!/bin/bash
#:
#: provision_wp.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Provisioning script for Wordpress stack VM "kc-wordpress"
#:

# Storage definitions & tunning
export partname="extrahd"
export partoffset=2
export partsize="2GB"
export device="/dev/sdc"
export pvname="/dev/sdc1"
export vgname="extra"
export lvname="mysql"
export mountdir="/var/lib/mysql"
export mapper="/dev/mapper/${vgname}-${lvname}"

# Run storage provisioning script
bash /vagrant/provision/common/storage.sh
