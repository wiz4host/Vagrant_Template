#!/bin/bash


pkgarrcentos=( wget mlocate bind-utils git )
pkgarrubuntu=( wget mlocate dnsutils git )
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
mkdir -p /opt/lab/shell_script

                                  