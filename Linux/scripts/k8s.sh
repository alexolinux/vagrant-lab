#!/bin/bash

# -- ------------------------------------------------------------------------------------------------
# Author: alexolinux
# Purpose: Script created for installing a kubernetes environment on Linux platforms based on RHEL.
# This script allows you to install and configure a Kubernetes cluster with control-plane and nodes.
# -- ------------------------------------------------------------------------------------------------
# https://gist.github.com/ed80cb54d6017e92ff8d791882f0de84.git
# -- ------------------------------------------------------------------------------------------------
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
# -- ------------------------------------------------------------------------------------------------

# Usage: ./k8s.sh (control/plane || node)

# Required Interface as Variable (i.e.: eth0, wlan0, etc)
IFACE=""

# Required Variables for node
# CONTROL_PLANE should have the Control Plane IP Address such as PORT (usually the default 6443).
# Both TOKEN and HASH values are provided after completed the Control Plane installation process.
CONTROL_PLANE=""
PORT=6443
TOKEN=""
HASH=""

# K8s Type: control-plane|node
usage() {
    echo "Usage: $0 <control-plane|node>"
    exit 1
}

# Prereqs for installation
prereq_kernel() {
    echo "Disabling SWAP..."
    sudo swapoff -a
    echo "Loading required kernel modules"
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

    sudo modprobe overlay
    sudo modprobe br_netfilter
}

prereq_params() {
    echo "Parameter Settings..."
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

    sudo sysctl --system
}

# Kubernetes packages installation 
# (PLEASE, CHECK THE REPO RELEASE VERSION!) <<<<<<<<<
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

# Change the Kubernetes Version if needed.
KUBE_VERSION="1.29"

install_k8s_packages() {
    echo "Installing required Kubernetes packages..."
    sudo tee /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
    sudo dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
    if [ $? -ne 0 ]; then
        echo "Error: Unable to install Kubernetes packages."
        exit 1
    fi
    sudo systemctl enable --now kubelet
    if [ $? -ne 0 ]; then
        echo "Error: Unable to start kubelet service."
        exit 1
    fi
}

# container runtime (using containerd)
configure_container_runtime() {
    echo "Configuring container runtime (containerd)..."
    sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf install -y containerd.io
    sudo containerd config default | sudo tee /etc/containerd/config.toml
    sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
    sudo systemctl enable --now containerd

    if [ $? -ne 0 ]; then
        echo "Error: Unable to start containerd service."
        exit 1
    fi
}

# Initializing control-plane

initialize_control_plane() {
    echo "Initializing Kubernetes control plane..."
    
    IP=$(ifconfig $IFACE | grep -Ei "inet " | awk '{print $2}')
    #sudo kubeadm init --pod-network-cidr=10.244.0.0/16

    if [ ! -z "$IP" ]; then
        ## Use the argument "--apiserver-advertise-address" if you have more than 1 Network Interface.
        #sudo kubeadm init --pod-network-cidr=10.10.0.0/16 --apiserver-advertise-address=${IP}
    sudo kubeadm init --pod-network-cidr=10.10.0.0/16 --kubernetes-version $KUBE_VERSION --apiserver-advertise-address=${IP}
    else
        echo "Error: Check Shellscript variables: IFACE/IP/KUBEVERSION."
        exit 1
    fi

    if [ $? -ne 0 ]; then
        echo "Error: Unable to initialize Kubernetes control plane."
        exit 1
    fi    
}

kube_user_config() {
    echo "Configure kubectl for the current user"
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

# Network plugin (using Calico)
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/

install_network_plugin() {
    echo "Installing Calico network plugin..."
    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
    if [ $? -ne 0 ]; then
        echo "Error: Unable to install Calico network plugin."
        exit 1
    fi
}

# Join node(s) to the cluster
join_node() {
    echo "Joining Kubernetes node to the cluster..."
    sudo kubeadm join $CONTROL_PLANE:$PORT --token $TOKEN \
    --discovery-token-ca-cert-hash $HASH

    if [ $? -ne 0 ]; then
        echo "Error: Unable to join Kubernetes node to the cluster."
        exit 1
    fi
}

# Main script

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    usage
fi

# Determine the type of installation based on the argument
case $1 in
    control-plane)
        prereq_kernel
        prereq_params
        install_k8s_packages
        configure_container_runtime
        initialize_control_plane
        kube_user_config
        install_network_plugin
        ;;
    node)
        prereq_kernel
        prereq_params
        install_k8s_packages
        configure_container_runtime
        join_node
        ;;
    *)
        echo "Invalid option. Use 'control-plane' or 'node'."
        usage
        ;;
esac

echo "Kubernetes installation and configuration completed."
