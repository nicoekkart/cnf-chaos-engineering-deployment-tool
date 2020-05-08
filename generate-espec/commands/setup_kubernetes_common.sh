#!/usr/bin/env bash

#apt-get update
#apt-get install -y apt-transport-https
#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#echo deb https://packages.cloud.google.com/apt/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list
#apt-get update
#apt-get install -y docker.io
#apt-get install -y kubelet kubeadm kubectl kubernetes-cni

#rm -rf /var/lib/kubelet/*
export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y git \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

# Install Docker (from https://docs.docker.com/install/linux/docker-ce/ubuntu/)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
apt update
apt install -y docker-ce docker-ce-cli containerd.io

# Install Kubectl (from https://kubernetes.io/docs/tasks/tools/install-kubectl/)
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

git clone https://github.com/nicoekkart/cnf-testbed.git
cd cnf-testbed/tools
docker build -t ubuntu:packet_api -f packet_api/Dockerfile packet_api/
docker build -t cnfdeploytools:latest -f deploy/Dockerfile deploy/
