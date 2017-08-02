# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  N = 3
  (1..N).each do |machine_id|
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.define "node#{machine_id}" do |machine|
      machine.vm.hostname = "node#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.50.#{20 + machine_id}", virtualbox__intnet: "ansible_network"
      machine.vbguest.auto_update = false
      #machine.vbguest.no_install = false
      #machine.vbguest.no_remote = true
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "node#{machine_id}"
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.cpus = 2
      end
    end
  end

  config.vm.define "opscenter" do |opscenter|
    opscenter.vm.box = "bento/ubuntu-16.04"
    opscenter.vm.synced_folder "./", "/vagrant"  # , :mount_options => ["ro"]
    opscenter.vm.hostname = "opscenter"
    opscenter.vm.network  "private_network", ip: "192.168.50.33", virtualbox__intnet: "ansible_network"
    opscenter.vbguest.auto_update = false
    opscenter.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = "opscenter"
    end
  end

  config.vm.define 'controller' do |controller|
    controller.vm.box = "bento/ubuntu-16.04"
    controller.vm.synced_folder "./", "/vagrant", owner: "vagrant", mount_options: ["dmode=775,fmode=600"]
    controller.vm.network "private_network", ip: "192.168.50.55", virtualbox__intnet: "ansible_network"
    controller.vm.hostname = "controller"
    controller.vbguest.auto_update = false  
    controller.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.name = "controller"
    end

    controller.vm.provision :ansible_local do |ansible|
      ansible.provisioning_path = "/vagrant/vagrant/provisioning"
      ansible.inventory_path = "inventory"
      ansible.playbook       = "site.yml"
      ansible.install        = true
      ansible.limit          = "all" # or only "nodes" group, etc.
    end

    controller.vm.provision :ansible_local do |ansible|
      ansible.provisioning_path = "/vagrant/vagrant/provisioning"
      ansible.inventory_path = "inventory"
      ansible.playbook       = "tasks/opscenter.yml"
      ansible.install        = true
      ansible.limit          = "all" # or only "nodes" group, etc.
    end
  end
end

