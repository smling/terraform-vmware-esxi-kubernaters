#! /bin/bash

# Usage: common.sh <<Host_Name>> <<Default_Password>>

# Variable Declaration
HOST_NAME=$1
DEFAULT_PASSWORD=$2
KUBERNETES_VERSION="1.24.3-00"

sudo hostnamectl set-hostname $HOST_NAME

# Initialize Kernal modules for containerd.
sudo cat << EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter 
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Initialize system settings for k8s networking.
sudo cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

# Initialize applications.
sudo apt update
sudo apt install -y apt-transport-https curl

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install containerd.
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install -y containerd.io

# Config containerd.
sudo mkdir -p /etc/containerd 
sudo containerd config default | sudo tee /etc/containerd/config.toml 
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml && grep 'SystemdCgroup' -B 11 /etc/containerd/config.toml
sudo systemctl enable --now containerd
sudo systemctl restart containerd

# Install Kubernetes.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt update
sudo apt install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet