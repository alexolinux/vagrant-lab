#!/bin/bash

# Update the system
dnf update -y

# Install epel-release
dnf install epel-release -y

# Install rpm fusion (free)
dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm -y

# Install rpm fusion (non-free)
dnf install https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm -y

# Clean the cache
dnf clean all

echo "All repositories are done!"