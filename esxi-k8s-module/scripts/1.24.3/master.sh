#! /bin/bash

# usage: master.sh <<POD_CIDR>>
# Example: master.sh 172.16.0.0/16
KUBERNETES_VERSION="1.24.3"
POD_NETWORK_CIDR=$1

# Initialize Kubernetes cluster.
sudo kubeadm init --pod-network-cidr $POD_NETWORK_CIDR --kubernetes-version $KUBERNETES_VERSION

# Setup local user settings.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Setup Calico
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Generate command for worker node to join cluster.
kubeadm token create --print-join-command > worker.sh