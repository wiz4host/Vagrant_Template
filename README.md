# Vagrant_Template
files for provisioning Virtual machine using Vagrant file in more effective way.

#Prerequisite: below software should be installed at your machine first
1. Virtualbox
2. Vagrant 


# files and their work:
1. Vagrantfile : This is main Vagrant file which have variables like hostname, memory and CPU count, IP etc
2. nodes.json : This file provides value to Vagrant file thus it has all information in JSON format regarding each node.
3. bootstrap-node.sh : This file is schell script file which runs while  vagrant up as post step for post actaions after VM get UP and running

If you are more specific, just check all files very closely. I kept the very common setting.

#How to use :
1. Create a directory: C:/my_vagrant

2. Go to C:/my_vagrant and Clone this repo: 
git clone https://github.com/wiz4host/Vagrant_Template.git

3. In nodes.json I mentioned two nodes to get provisioned: node001 (CENTOS) and node002 (UBUNTU).

4. Check for Vagrant file for required OS . I mentioned CentOS 7 for node001 and Ubuntu 14 for node002.
  if node_name == 'node001'
	    config.vm.box="bento/ubuntu-14.04"
	  end
	  if node_name == 'node002'
	    config.vm.box="bento/centos-7.3"
	  end

5. Edit nodes.json if you want and provide details as per your choice ( otherwise you can go with value what I provided if your host machine is capabale to allocate that much resource):

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

6. bootstrap-node.sh will automatically identify OS flavour ( Only centos and UBUNTU) and  run at last and install these packages for you:
if UBUNTU: wget mlocate dnsutils git
if CENTOS: mlocate bind-utils git
You can edit the packages as per your need before running vagrant up if you want.

7. And lastly ==> Run: "vagrant up"




Your all comments and modification requests are most welcome. Go ahead and fork it and modify it as per your need.











