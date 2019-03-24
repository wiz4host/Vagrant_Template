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

#nodes.json is single truth for nodes specifications like OS, memory IP etc

3. In nodes.json I mentioned three nodes to get provisioned: node001 (UBUNTU-14), node002 (CENTOS-7) and node003 (UBUNTU-16). 

4. Edit nodes.json if you want and provide details as per your choice ( otherwise you can go with value what I provided if your host machine is capable to allocate that much resource):
{
  "nodes": {
    "node001": {
      ":ip": "10.0.0.131",
      "ports": [],
      ":memory": 1024,
	  ":os": "bento/ubuntu-14.04",
      ":bootstrap": "bootstrap-node.sh"
    },
    
    "node002": {
      ":ip": "10.0.0.132",
      "ports": [],
      ":memory": 1024,
	  ":os": "bento/centos-7.4",
      ":bootstrap": "bootstrap-node.sh"
    },
	
	"node003": {
      ":ip": "10.0.0.132",
      "ports": [],
      ":memory": 1024,
	  ":os": "bento/ubuntu-16.04",
      ":bootstrap": "bootstrap-node.sh"
    }
  }
}



5. bootstrap-node.sh will automatically identify OS flavor ( Only centos and UBUNTU) and run at last and install these packages for you:
 if UBUNTU: wget, mlocate, dnsutils, git 
 if CENTOS: mlocate, bind-utils, git
 You can edit the packages as per your need before running vagrant up if you want.
 
 
6. And lastly ==> Run: "vagrant up"
Your all comments and modification requests are most welcome. Go ahead and fork it and modify it as per your need.
