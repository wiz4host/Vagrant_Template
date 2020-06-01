
This vagrant Project is for creating Kubernetes cluster with 1 master and 2 nodes

Prerequisite:

  - [ MANDATORY ]
       
       Create ssh key pair files with name and keep them in this project:
       
         a) id_rsa_k8s
         b) id_rsa_k8s.pub
         
  - [ OPTIONAL ]
  
       if ":mount: true" is set  inside any/all nodes inside nodes.json, it means you are trying to mount any host shared directory inside your   guest Vms. If so,
        
          a) first share the directory at your host machine
          b) give read/write permission to share directory with  machine account user
          c) keep ready your username/password and enter it in bootstrap-002.sh by substituting
             - <YOUR_HOST_MACHINE_USERNAME>
             - <YOUR_HOST_MACHINE_USERNAMEs_PASSWORD>
            

 NOTE:
 
    nodes.json 
 is the file where user needs to provide the VM specifications. No other modifications are required.
