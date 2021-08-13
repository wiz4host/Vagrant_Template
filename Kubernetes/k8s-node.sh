#!/bin/bash
#https://vitux.com/install-and-deploy-kubernetes-on-ubuntu/
echo "10.1.1.131 k8s001 k8s001.local.domain" >> /etc/hosts
echo "10.1.1.132 k8s002 k8s002.local.domain" >> /etc/hosts
echo "10.1.1.133 k8s003 k8s003.local.domain" >> /etc/hosts

#permission fix for Private Key
sudo mkdir ${HOME}/.ssh
sudo mv /tmp/id_rsa_k8s ${HOME}/.ssh/
sudo chmod 700 ${HOME}/.ssh
sudo chmod 600 ${HOME}/.ssh/id_rsa_k8s
sudo chown -R root:root ${HOME}/.ssh
sudo dos2unix ${HOME}/.ssh/id_rsa_k8*




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

#Disable swap memory  on BOTH
 sudo swapoff -a
 sudo sed -i 's/.* none.* swap.* sw.*/#&/' /etc/fstab

#Give Unique hostnames to each node
sudo hostnamectl set-hostname $HOSTNAME

#enable and start
#echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet



# sudo kubectl get nodes
# nodeIP=$(ifconfig | grep "10.1.1." | awk -F"inet addr:" '{print $2}' |awk '{print $1}')

while true;
  do
    code=$(curl -I -k -s https://10.1.1.131:6443 | head -1 | awk '{print $2}');
    if [[ "$code" == 403 ]]; then
      kubeadmjoincmd=$(ssh -i ${HOME}/.ssh/id_rsa_k8s -o StrictHostKeyChecking=no vagrant@10.1.1.131 "grep -A1 \"kubeadm join 10.1.1.131:6443 --token\" /tmp/kubeadm-init.log")
      echo "API is UP. Attempting to join....."
      sleep 60
      kubeadmjoincmd=$(echo $kubeadmjoincmd | sed 's|\\||g')
      $kubeadmjoincmd
      break;
    else
      echo "Still waiting for API ..."
      sleep 10
    fi
  done


#Copy .kube from master so that kubectl can be run from nodes as well which will connect to same master API.
  while true;
    do
      ssh -i ${HOME}/.ssh/id_rsa_k8s -o StrictHostKeyChecking=no vagrant@10.1.1.131 "ls -d /tmp/.kube"
      if [ $? == 0 ]; then
        echo "Ready to copy ~/.kube..."
        sudo scp -o StrictHostKeyChecking=no -i ${HOME}/.ssh/id_rsa_k8s -rp vagrant@10.1.1.131:/tmp/.kube /tmp/
        ls -ltr /tmp
        ls -ltr /tmp
        break;
      else
        echo "waiting for ~/.kube at master node"
        sleep 5
      fi
    done
    sleep 5
    sudo cp -rp /tmp/.kube ${HOME}/
    sudo chown -R root:root ${HOME}
    ls -ltra ${HOME}



#Add the slave node to the network
sudo kubectl get pods,nodes,services,deployments,replicasets --all-namespaces


echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                                  k8s-node.sh done
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
