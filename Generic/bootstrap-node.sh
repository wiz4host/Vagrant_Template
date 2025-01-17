#!/bin/bash



pkgarrRocky=( wget mlocate bind-utils git curl tree dos2unix cifs-utils )
pkgarrubuntu=( wget mlocate dnsutils git curl tree dos2unix cifs-utils )
updaterepo="y"

#grep linux  OS  type
oslinux=$(cat /etc/*-release| grep -w 'NAME='|awk -F "=" '{print $2}'|sed -e 's/^"//' -e 's/"$//'|awk -F " " '{print $1}')

#convert $os  all in lowercase
os="${oslinux,,}"


#compare for ubuntu or Rocky
if [[ $os == "ubuntu" ]]; then
   osinstaller="apt-get"
   pkgarr=${pkgarrubuntu[@]}
fi

if [ $os == "Rocky" ]; then
   osinstaller="dnf "
   pkgarr=${pkgarrRocky[@]}
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

                                  
