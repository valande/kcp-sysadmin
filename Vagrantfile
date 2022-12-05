# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "kc-wordpress" do |wp|
    wp.vm.box = "ubuntu/focal64"
    wp.vm.hostname = "kc-wordpress"
    wp.vm.box_check_update = false
    wp.vm.provider "virtualbox" do |vbox|
      vbox.name = "wp"
      vbox.memory = "1024"
    end
  end

  config.vm.define "kc-elk" do |elk|
    elk.vm.box = "ubuntu/focal64"
    elk.vm.hostname = "kc-elk"
    elk.vm.box_check_update = false
    elk.vm.provider "virtualbox" do |vbox|
      vbox.name = "elk"
      vbox.memory = "4096"
    end
  end
end