# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define 'zabbix' do |zabbix|
    zabbix.vm.box = "envimation/ubuntu-xenial-docker"
    zabbix.vm.network "private_network", ip: "192.168.50.50", virtualbox__intnet: "ansible_network"
    zabbix.vm.network "public_network", bridge: "eno1", use_dhcp_assigned_default_route: true
    zabbix.vm.hostname = "zabbix"
    zabbix.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.name = "zabbix"
    end

    zabbix.vm.provision :ansible do |ansible|
      ansible.limit = "zabbix"
      ansible.playbook = "run-first-python2.yml"
    end

    zabbix.vm.provision :ansible do |ansible|
      ansible.limit = "zabbix"
      ansible.playbook = "zabbix.yml"
    end
  end

  N = 3
  (1..N).each do |machine_id|
    config.vm.box = "envimation/ubuntu-xenial-docker"
    config.vm.define "nd#{machine_id}" do |machine|
      machine.vm.hostname = "nd#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.50.#{10 + machine_id}", virtualbox__intnet: "ansible_network"
      # machine.vm.network "public_network", ip: "10.100.100.#{10 + machine_id}", bridge: "bridge0"

      machine.vm.provider "virtualbox" do |vb|
        vb.name = "nd#{machine_id}"
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.cpus = 2
      end

      if machine_id == N
        machine.vm.provision :ansible do |ansible|
          ansible.limit = "all"
          ansible.playbook = "run-first-python2.yml"
        end
        machine.vm.provision :ansible do |ansible|
          ansible.limit = "all"
          ansible.playbook = "site.yml"
        end
      end
    end
  end

end
