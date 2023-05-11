#!/bin/bash

HOSTIP='192.168.1.74'
HOSTNAME='host'
HOSTALIAS='master'

echo -e "1. Appending Hosts\n"
# Adding Public DNS Resolvers (Change to your desired list of hosts)
sudo echo "$HOSTIP $HOSTNAME $HOSTALIAS" | sudo tee -a /etc/hosts

echo -e "2. Installing extra packages\n"
# Extra packages
# List of packages to be installed
Packages=(
  "glances"
  "net-tools"
  "bind-utils"
  "tcpdump"
  "iperf3"
  "jq"
)
for package in ${Packages[@]}; do
    sudo dnf install -y $package
done
