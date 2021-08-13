#!/bin/bash
#https://vitux.com/install-and-deploy-kubernetes-on-ubuntu/
echo "10.1.1.131 k8s001 k8s001.local.domain" >> /etc/hosts
echo "10.1.1.132 k8s002 k8s002.local.domain" >> /etc/hosts
echo "10.1.1.133 k8s003 k8s003.local.domain" >> /etc/hosts

#Inserting Public key
#permission fix for Private Key
SSHUSER='vagrant'

sudo mkdir -p /home/$SSHUSER/.ssh/
sudo mv /tmp/id_rsa_k8s.pub /home/$SSHUSER/.ssh/
sudo chmod 700 /home/$SSHUSER/.ssh
sudo chmod 600 /home/$SSHUSER/.ssh/id_rsa_k8s.pub
sudo chown -R $SSHUSER:$SSHUSER /home/$SSHUSER/.ssh
sudo dos2unix /home/$SSHUSER/.ssh/id_rsa_k8*
sudo cat /home/$SSHUSER/.ssh/id_rsa_k8s.pub | sudo tee -a /home/$SSHUSER/.ssh/authorized_keys
sudo chmod 600 /home/$SSHUSER/.ssh/authorized_keys


ls -ltr /home/$SSHUSER/
ls -ltr ${HOME}



#Install and enable docker on BOTH
sudo apt install -y curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
# Install Docker CE
apt-get update && apt-get install -y \
  containerd.io=1.2.13-1 \
  docker-ce=5:19.03.8~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.8~3-0~ubuntu-$(lsb_release -cs)
# Set up the Docker daemon
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
sed -i 's|GRUB_CMDLINE_LINUX=\"\"|GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"|g' /etc/default/grub
# Restart Docker
systemctl daemon-reload
systemctl restart docker



#Install curl on BOTH
sudo apt install -y curl

# Add Xenial Kubernetes Repository on BOTH
#sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF


#Install Kubeadm on BOTH
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
kubeadm version

##Disable swap memory  on BOTH
 sudo swapoff -a
 sudo sed -i 's/.* none.* swap.* sw.*/#&/' /etc/fstab

#Give Unique hostnames to each node
sudo hostnamectl set-hostname $HOSTNAME
#echo "KUBELET_EXTRA_ARGS=--cgroup-driver=systemd" >> /etc/default/kubelet

#enable and start
systemctl daemon-reload
systemctl restart kubelet

#Initialize Kubernetes on the master node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.1.1.131 >> /tmp/kubeadm-init.log 2>&1
chmod 777 /tmp/kubeadm-init.log
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo cp -rp /$HOME/.kube /tmp/
sudo chown -R $SSHUSER:$SSHUSER /tmp/.kube


#Deploy a Pod Network on master
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#get nodes
sudo kubectl get pods,nodes,services,deployments,replicasets --all-namespaces


echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                                  k8s-master.sh done
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
