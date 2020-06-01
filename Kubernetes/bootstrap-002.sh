#Run this if you want to Mount your Host Shared directory (Shared) at Guest VM
#!/bin/bash

samba_mount () {
  sudo mkdir -p /mnt/$1
  cat << EOF > /var/smbcredentials
   username=<YOUR_HOST_MACHINE_USERNAME>
   password=<YOUR_HOST_MACHINE_USERNAMEs_PASSWORD>
EOF

 sudo chmod 600 /var/smbcredentials
 sudo mount.cifs --verbose //$2/$3 /mnt/$1 -o user=<YOUR_HOST_MACHINE_USERNAME>,pass=<YOUR_HOST_MACHINE_USERNAMEs_PASSWORD>,vers=2.0 0 0
 echo "$2/$3 /mnt/$1 cifs credentials=/var/smbcredentials 0 0" | sudo tee -a /etc/fstab
}


samba_mount "wsdata" "192.168.0.105" "wsdata-k8s"

echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                                  bootstrap-002.sh done
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
