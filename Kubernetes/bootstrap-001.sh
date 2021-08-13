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

pkgarrcentos=( wget mlocate bind-utils git vim cifs-utils dos2unix)
pkgarrubuntu=( wget mlocate dnsutils git vim tree cifs-utils dos2unix)
updaterepo="y"

#grep linux  OS  type
oslinux=$(cat /etc/*-release| grep -w 'NAME='|awk -F "=" '{print $2}'|sed -e 's/^"//' -e 's/"$//'|awk -F " " '{print $1}')

#convert $os  all in lowercase
os="${oslinux,,}"


#compare for ubuntu or centos
if [[ $os == "ubuntu" ]]; then
   osinstaller="apt-get"
   pkgarr=${pkgarrubuntu[@]}
fi

if [ $os == "centos" ]; then
   osinstaller="yum"
   pkgarr=${pkgarrcentos[@]}
fi

echo "===================================================================="
echo "Linux OS = $os"
echo "package to be installed = ${pkgarr[@]}"
echo "===================================================================="

export DEBIAN_FRONTEND=noninteractive
echo  ++++++++++++++++++++++++++++++++++++++++++ UPDATE Packages and Repos++++++++++++++++++++++++++++++
if [[ $updaterepo == "y" ]]; then
    sudo $osinstaller update -y
fi

echo +++++++++++++++++++++++++++++++++++++++++++INSTALL Package++++++++++++++++++++++++++++

for pkg in ${pkgarr[@]}
 do
  sudo $osinstaller -y install $pkg|grep -w 'Package'
 done

updatedb
samba_mount "wsdata" "10.1.1.1" "wsdata-k8s"
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                                  bootstrap.sh done
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
