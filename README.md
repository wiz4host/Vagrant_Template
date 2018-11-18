# Vagrant_Template
files for provisioning Virtual machine using Vagrant file in more effective way.

Hashicorp Vagrant is indeed very powerful for spinning up VMs. But you will feel it’s real  power when you use it in more smarter way. Here is how you can make use of  Vagrant more effectively and systematic. You can keep your System more cleaner and less confusing. You only need to manage one JSON file in which you will provide your all VMs details instead of writing separate Vagrantfile for your each VM:
 # Prerequisite:
Below software should be installed at your machine first

Virtualbox
Vagrant

Create a directory anywhere in your system in which you want to start vagrant stuff. Lets assume it’s C:/my_vagrant

Clone the wiz4host Vagrant Github repository:  https://github.com/wiz4host/Vagrant_Template.git

# files and their work:
1. Vagrantfile : This is main Vagrant file which have variables like hostname, memory and CPU count, IP etc
2. nodes.json : This file provides value to Vagrantfile. Thus it has all information in JSON format regarding each node. This will be your single source of truth for defining your all VM and their configuration
3. bootstrap-node.sh : This file is schell script file which runs while vagrant up as post step for post actions after VM get UP and running

If you are more specific, just check all files very closely. I kept the very common setting.


# How to use :
1. Create a directory: "C:/my_vagrant"

2. Go to C:/my_vagrant and Clone this repo: "git clone https://github.com/wiz4host/Vagrant_Template.git"

3. In nodes.json I mentioned two nodes to get provisioned: node001 (CENTOS) and node002 (UBUNTU).

4. Check for Vagrantfile for required OS . I mentioned CentOS 7  for node001 and Ubuntu 14 for  node002. 
if node_name == 'node001'
  config.vm.box="bento/ubuntu-14.04" 
end 
if node_name == 'node002' 
  config.vm.box="bento/centos-7.3" 
end

5. Edit nodes.json if you want and provide details as per your choice ( otherwise you can go with value what I provided if your host machine is capable to allocate that much resource):
{
  "nodes": {
    "node001": {
      ":ip": "10.0.0.15",
      "ports": [],
      ":memory": 1024,
      ":bootstrap": "bootstrap-node.sh"
    },
    "node002": {
      ":ip": "10.0.0.16",
      "ports": [],
      ":memory": 1024,
      ":bootstrap": "bootstrap-node.sh"
    }
  }
}


6. bootstrap-node.sh will automatically identify OS flavor ( Only centos and UBUNTU) and run at last and install these packages for you:
 if UBUNTU: wget, mlocate, dnsutils, git 
 if CENTOS: mlocate, bind-utils, git
 You can edit the packages as per your need before running vagrant up if you want.
 
 
7. And lastly ==> Run: "vagrant up"
Your all comments and modification requests are most welcome. Go ahead and fork it and modify it as per your need.
