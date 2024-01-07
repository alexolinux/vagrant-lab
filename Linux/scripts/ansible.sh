#!/bin/bash

# Ansible script Installation
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible

# Install Ansible
sudo dnf -y install ansible

# Verify Ansible installation
if [ $? -eq 0 ]; then
    echo "Ansible is installed."
    ansible --version
else
    echo "Failure to install Ansible."
    echo "Error code: ${$?}"
fi