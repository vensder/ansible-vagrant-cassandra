# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant.configure("2") do |config|
#   # The default ubuntu/xenial64 image has issues with vbguest additions
#   # config.vm.box = "hashicorp/precise64"
#   config.vm.box = "bento/ubuntu-16.04"

#   #  Intel(R) Ethernet Connection (2) I219-LM
#   #  config.vm.network "public_network", bridge: "Intel(R) Ethernet Connection (2) I219-LM"

#   config.vm.define "host1" do |host1|
#     host1.vm.network :private_network, ip: "192.168.50.11", virtualbox__intnet: "ansible_network"
#     host1.vm.hostname = "host1"
#     host1.vm.synced_folder ".", "/vagrant", disabled: true

#     # Set memory for the default VM
#     host1.vm.provider "virtualbox" do |vb|
#       vb.memory = "512"
#       vb.name = "host1"
#     end
#   end
  
#   config.vm.define "ansible" do |ansible|
#     ansible.vm.network "private_network", ip: "192.168.50.50", virtualbox__intnet: "ansible_network"
#     ansible.vm.hostname = "ansible"

#     # Set memory for the default VM
#     ansible.vm.provider "virtualbox" do |vb|
#         vb.memory = "512"
#         vb.name = "ansible"
#     end

#     # Configure vbguest auto update options
#     ansible.vbguest.auto_update = false
#     ansible.vbguest.no_install = false
#     ansible.vbguest.no_remote = true

#     # Mount this folder as RO in the guest, since it contains secure stuff
#     ansible.vm.synced_folder "vagrant", "/vagrant", :mount_options => ["ro"]

#     # And finally run the Ansible local provisioner
#     ansible.vm.provision "ansible_local" do |ansible|
#       ansible.provisioning_path = "/vagrant/provisioning"
#       ansible.inventory_path = "inventory"
#       ansible.playbook = "playbook.yml"
#       ansible.limit = "all"
#     end
#   end
# end

Vagrant.configure("2") do |config|

  N = 3
  (1..N).each do |machine_id|
    config.vm.box = "bento/ubuntu-16.04"
    # config.vm.box = "geerlingguy/ubuntu1604"
    # config.vm.box_url = "https://vagrantcloud.com/geerlingguy/boxes/ubuntu1604"
    config.vm.define "node#{machine_id}" do |machine|
      # Mount this folder as RO in the guest, since it contains secure stuff
      # machine.vm.synced_folder "vagrant", "/vagrant", :mount_options => ["ro"]
      machine.vm.hostname = "node#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.50.#{20 + machine_id}", virtualbox__intnet: "ansible_network"
      # Configure vbguest auto update options
      machine.vbguest.auto_update = false
      #machine.vbguest.no_install = false
      #machine.vbguest.no_remote = true

  # Mount this folder as RO in the guest, since it contains secure stuff
  #config.vm.synced_folder "vagrant", "/vagrant", :mount_options => ["ro"]
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "node#{machine_id}"
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.cpus = 2
        # if machine_id == N
        #   machine.vm.provision "ansible_local" do |ansible|
        #     ansible.provisioning_path = "/vagrant/provisioning"
        #     ansible.inventory_path = "inventory"
        #     ansible.playbook = "site.yml"
        #     ansible.limit = "all"
        #   end
        # end
      end
    end
  end

  config.vm.define "opscenter" do |opscenter|
    # Mount this folder as RO in the guest, since it contains secure stuff
    opscenter.vm.box = "bento/ubuntu-16.04"
    opscenter.vm.synced_folder "./", "/vagrant"  # , :mount_options => ["ro"]
    # opscenter.vm.box = "geerlingguy/ubuntu1604"
    opscenter.vm.hostname = "opscenter"
    opscenter.vm.network  "private_network", ip: "192.168.50.33", virtualbox__intnet: "ansible_network"
    # Configure vbguest auto update options
    opscenter.vbguest.auto_update = false
    #opscenter.vbguest.no_install = false
    #opscenter.vbguest.no_remote = true

    opscenter.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = "opscenter"
    end
  end
  
    
    # opscenter.vm.provision "ansible_local" do |machine|
    #   # ansible.provisioning_path = "/vagrant/provisioning"
    #   # ansible.inventory_path = "inventory"
    #   # ansible.verbose = "-vvv"
    #   # ansible.playbook = "tasks/opscenter.yml"
    #   machine.vm.provider "virtualbox" do |vb|
    #     vb.customize ["modifyvm", :id, "--memory", "2048"]
    #   end
    # end
  

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
      # ansible.playbook       = "tasks/opscenter.yml"
      # ansible.verbose        = true
      ansible.install        = true
      ansible.limit          = "all" # or only "nodes" group, etc.
    end

    controller.vm.provision :ansible_local do |ansible|
      ansible.provisioning_path = "/vagrant/vagrant/provisioning"
      ansible.inventory_path = "inventory"
      # ansible.playbook       = "site.yml"
      ansible.playbook       = "tasks/opscenter.yml"
      # ansible.verbose        = true
      ansible.install        = true
      ansible.limit          = "all" # or only "nodes" group, etc.
    end



  end
  
end

