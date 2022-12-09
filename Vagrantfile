# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # -- VM2: Nginx + ELK Stack
  config.vm.define "kc-elk" do |elk|
    elk.vm.box = "ubuntu/focal64"
    elk.vm.hostname = "kc-elk"
    elk.vm.network  "private_network", ip: "192.168.100.4", netmask: "29", virtualbox__intnet: "mired", nic_type: "virtio"
    elk.vm.network "forwarded_port", guest: 80, host: 8081
    elk.vm.network "forwarded_port", guest: 9200, host: 9200
    elk.vm.box_check_update = false
    elk.vm.provider "virtualbox" do |vbox|
      vbox.name = "elk"
      vbox.memory = "4096"
      vbox.cpus = 2
      elk_extra_disk = "./storage/elk-extra.vmdk"
      unless File.exist?(elk_extra_disk)
        vbox.customize [ "createmedium", "disk", "--filename", elk_extra_disk, "--format", "VMDK", "--size", 1024 * 4 ]
      end
      vbox.customize [ "storageattach", :id , "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", elk_extra_disk ]
    end
    elk.vm.provision "shell", path: "./provision/provision_elk.sh"
  end

  # -- VM1: Nginx + Wordpress + MariaDB + Filebeat
  config.vm.define "kc-wordpress" do |wp|
    wp.vm.box = "ubuntu/focal64"
    wp.vm.hostname = "kc-wordpress"
    wp.vm.network  "private_network", ip: "192.168.100.2", netmask: "29", virtualbox__intnet: "mired", nic_type: "virtio"
    wp.vm.network "forwarded_port", guest: 80, host: 8080
    wp.vm.box_check_update = false
    wp.vm.provider "virtualbox" do |vbox|
      vbox.name = "wp"
      vbox.memory = "1024"
      vbox.cpus = 1
      wp_extra_disk = "./storage/wp-extra.vmdk"
      unless File.exist?(wp_extra_disk)
        vbox.customize [ "createmedium", "disk", "--filename", wp_extra_disk, "--format", "VMDK", "--size", 1024 * 2 ]
      end
      vbox.customize [ "storageattach", :id , "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", wp_extra_disk ]
    end
    wp.vm.provision "shell", path: "./provision/provision_wp.sh"
  end
  
end