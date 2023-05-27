#!/bin/bash

# Update the system
dnf update -y
# Install epel-release
dnf install epel-release -y
# Install rpm fusion
#dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
#dnf install -y https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
# Clean the cache
dnf clean all

echo "All repositories are done!"
