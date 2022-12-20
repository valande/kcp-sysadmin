#!/bin/bash
#:
#: storage.sh  [ valande@gmail.com ]
#: --------------------------------------------------------
#: Common storage provisioning script for VMs
#:

# Prepare disk partition, if needed
if [ ! -b ${pvname} ]; then
parted -s ${device} mklabel gpt
parted -s ${device} mkpart ${partname} ${partoffset} ${partsize}
parted -s ${device} set 1 lvm on
fi

# Create volume and make it an ext4 filesystem, if needed
pvexist=$(pvdisplay | grep "PV Name" | awk '{print $3}' | grep "${pvname}")
vgexist=$(vgdisplay | grep "VG Name" | awk '{print $3}' | grep "${vgname}")
lvexist=$(lvdisplay | grep "LV Name" | awk '{print $3}' | grep "${lvname}")
[ -z "${pvexist}" ] && pvcreate ${pvname}
[ -z "${vgexist}" ] && vgcreate ${vgname} ${pvname}
[ -z "${lvexist}" ] && lvcreate -l 100%VG -n ${lvname} ${vgname} && mkfs.ext4 ${mapper}

# Create 'mountdir'
mkdir -p ${mountdir}

# Add fstab entry 
if ! grep -q "${mountdir}.*ext4" /etc/fstab; then
cat << _EOF_ >> /etc/fstab
# ${lvname} volume
${mapper} ${mountdir} ext4 defaults,auto,nofail 0 0
_EOF_
fi

# Mount logical volume on 'mountdir'
count=$( mount | grep -c "${mountdir}.*ext4" )
[ $count -eq 0 ] && mount ${mountdir}
