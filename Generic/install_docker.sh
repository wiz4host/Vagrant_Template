#!/bin/bash

want2install_docker="yes"
#grep linux  OS  type
oslinux=$(cat /etc/*-release| grep -w 'NAME='|awk -F "=" '{print $2}'|sed -e 's/^"//' -e 's/"$//'|awk -F " " '{print $1}')

#convert $os  all in lowercase
os="${oslinux,,}"
if [[ $os == "ubuntu" ]]; then
   osinstaller="apt-get"
fi
if [ $os == "centos" ]; then
   osinstaller="yum"
fi

if [ $want2install_docker == "yes" ]; then
    sudo $osinstaller update -y
    sudo $osinstaller check-update -y
    curl -fsSL https://get.docker.com/ | sh
    sudo systemctl start docker
    sudo systemctl status docker
    sudo systemctl enable docker
    sudo usermod -aG docker $(whoami)
    sudo usermod -aG docker username
    docker info
    docker run hello-world
    docker ps -a
    echo "docker installation done!!"
else
    echo "docker installation in NOT required"
fi
