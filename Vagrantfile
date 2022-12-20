# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # -- VM2: Nginx + ELK Stack
  config.vm.define "kc-elk" do |elk|
    elk.vm.box = "ubuntu/focal64"
    elk.vm.hostname = "kc-elk"
    elk.vm.network  "private_network", ip: "192.168.100.4", netmask: "29", virtualbox__intnet: "sysadmtasknet", nic_type: "virtio"
    elk.vm.network "forwarded_port", guest: 80, host: 8081
    elk.vm.network "forwarded_port", guest: 5044, host: 5044
    elk.vm.box_check_update = false
    elk.vm.provider "virtualbox" do |vbox|
      vbox.name = "elk"
      vbox.memory = "4096"
      vbox.cpus = 1
      extra_disk = "./storage/elasticsearch.vmdk"
      unless File.exist?(extra_disk)
        vbox.customize [ "createmedium", "disk", "--filename", extra_disk, "--format", "VMDK", "--size", 1024 * 2 ]
      end
      vbox.customize [ "storageattach", :id , "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", extra_disk ]
    end
    elk.vm.provision "shell", path: "./provision/provision_elk.sh"
  end

  # -- VM1: Nginx + Wordpress + MariaDB + Filebeat
  config.vm.define "kc-wordpress" do |wp|
    wp.vm.box = "ubuntu/focal64"
    wp.vm.hostname = "kc-wordpress"
    wp.vm.network  "private_network", ip: "192.168.100.2", netmask: "29", virtualbox__intnet: "sysadmtasknet", nic_type: "virtio"
    wp.vm.network "forwarded_port", guest: 80, host: 8080
    wp.vm.box_check_update = false
    wp.vm.provider "virtualbox" do |vbox|
      vbox.name = "wp"
      vbox.memory = "1024"
      vbox.cpus = 1
      extra_disk = "./storage/mariadb.vmdk"
      unless File.exist?(extra_disk)
        vbox.customize [ "createmedium", "disk", "--filename", extra_disk, "--format", "VMDK", "--size", 1024 * 1 ]
      end
      vbox.customize [ "storageattach", :id , "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", extra_disk ]
    end
    wp.vm.provision "shell", path: "./provision/provision_wp.sh"
  end
  
end