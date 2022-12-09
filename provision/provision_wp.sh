#!/bin/bash
#:
#: provision_wp.sh  [ valande@gmail.com - 09/12/2022 ]
#: --------------------------------------------------------
#: Bash script to have Wordpress virtual machine provisioned
#:

# Some definitions
partname="extrahd"
device="/dev/sdc"
pvname="/dev/sdc1"
vgname="extra"
lvname="mysql"
mysql_directory="/var/lib/mysql"
mysql_lvmapper="/dev/mapper/${vgname}-${lvname}"

# Prepare disk partition, if needed
if [ ! -b ${pvname} ]; then
    parted -s ${device} mklabel gpt
    parted -s ${device} mkpart ${partname} 2 2GB
    parted -s ${device} set 1 lvm on
fi

# Create volume and make it an ext4 filesystem, if needed
pvexist=$(pvdisplay | grep "PV Name" | awk '{print $3}' | grep "${pvname}")
vgexist=$(vgdisplay | grep "VG Name" | awk '{print $3}' | grep "${vgname}")
lvexist=$(lvdisplay | grep "LV Name" | awk '{print $3}' | grep "${lvname}")
[ -z "${pvexist}" ] && pvcreate ${pvname}
[ -z "${vgexist}" ] && vgcreate ${vgname} ${pvname}
[ -z "${lvexist}" ] && lvcreate -l 100%VG -n ${lvname} ${vgname} && mkfs.ext4 ${mysql_lvmapper}

# Create directory for mysql
mkdir -p ${mysql_directory}

# Add fstab entry 
if ! grep -q "${mysql_directory}.*ext4" /etc/fstab; then
cat << EOF >> /etc/fstab
# mysql volume
${mysql_lvmapper} ${mysql_directory} ext4 defaults,auto,nofail 0 0
EOF
fi

# Mount mysql logical volume on /var/lib/mysql
count=$( mount | grep -c "${mysql_directory}.*ext4" )
[ $count -eq 0 ] && mount ${mysql_directory}

