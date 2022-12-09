#!/bin/bash
#:
#: provision_elk.sh  [ valande@gmail.com - 08/12/2022 ]
#: --------------------------------------------------------
#: Bash script to have ELK virtual machine provisioned
#:

# Some definitions
partname="extrahd"
device="/dev/sdc"
pvname="/dev/sdc1"
vgname="extra"
lvname="elasticsearch"
elastic_directory="/var/lib/elasticsearch"
elastic_lvmapper="/dev/mapper/${vgname}-${lvname}"

# Prepare disk partition, if needed
if [ ! -b ${pvname} ]; then
    parted -s ${device} mklabel gpt
    parted -s ${device} mkpart ${partname} 2 4GB
    parted -s ${device} set 1 lvm on
fi

# Create volume and make it an ext4 filesystem, if needed
pvexist=$(pvdisplay | grep "PV Name" | awk '{print $3}' | grep "${pvname}")
vgexist=$(vgdisplay | grep "VG Name" | awk '{print $3}' | grep "${vgname}")
lvexist=$(lvdisplay | grep "LV Name" | awk '{print $3}' | grep "${lvname}")
[ -z "${pvexist}" ] && pvcreate ${pvname}
[ -z "${vgexist}" ] && vgcreate ${vgname} ${pvname}
[ -z "${lvexist}" ] && lvcreate -l 100%VG -n ${lvname} ${vgname} && mkfs.ext4 ${elastic_lvmapper}

# Create directory for elasticsearch 
mkdir -p ${elastic_directory}

# Add fstab entry 
if ! grep -q "${elastic_directory}.*ext4" /etc/fstab; then
cat << EOF >> /etc/fstab
# elasticsearch volume
${elastic_lvmapper} ${elastic_directory} ext4 defaults,auto,nofail 0 0
EOF
fi

# Mount elastic logical volume on /var/lib/elasticsearch
count=$( mount | grep -c "${elastic_directory}.*ext4" )
[ $count -eq 0 ] && mount ${elastic_directory}

