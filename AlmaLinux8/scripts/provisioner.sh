#!/bin/bash

# Add your Host Ip/Name below this line to your HOSTIP/HOSTALIAS environment variable.
HOSTIP=192.168.1.10
HOSTALIAS='master'

echo -e "1. Appending Hosts\n"
# Adding Public DNS Resolvers (Change to your desired list of hosts)
sudo echo -e "$HOSTIP \t$HOSTALIAS" | sudo tee -a /etc/hosts

echo -e "2. Installing extra packages\n"
# Extra packages
# List of packages to be installed
Packages=(
  "wget"
  "vim"
  "curl"
  "git"
  "mlocate"
  "gcc"
  "gcc-c++"
  "make"
  "automake"
  "autoconf"
  "net-tools"
  "bind-utils"
  "tcpdump"
  "nmap"
  "nc"
  "iperf3"
  "jq"
)
for package in ${Packages[@]}; do
  sudo dnf install -y $package
done
