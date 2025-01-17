#!/bin/bash

want2install_docker="yes"
#grep linux  OS  type
oslinux=$(cat /etc/*-release| grep -w 'NAME='|awk -F "=" '{print $2}'|sed -e 's/^"//' -e 's/"$//'|awk -F " " '{print $1}')

#convert $os  all in lowercase
os="${oslinux,,}"
if [[ $os == "ubuntu" ]]; then
   osinstaller="apt-get"
fi
if [ $os == "Rocky" ]; then
   osinstaller="dnf"
fi

if [ "$want2install_docker" == "yes" ]; then
    sudo $osinstaller update -y
    sudo $osinstaller check-update
    curl -fsSL https://get.docker.com/ | sh
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl status docker
    sudo usermod -aG docker $(whoami)
    echo "You must log out and log back in for Docker group changes to take effect."
    docker info
    docker run hello-world
    docker ps -a
    echo "docker installation done!!"
else
    echo "docker installation is NOT required"
fi
