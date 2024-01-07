#!/bin/bash

# Check if GDM is already installed
if ! rpm -q gdm > /dev/null 2>&1; then
    # Install GDM package
    sudo dnf install -y gdm
fi

# Check if GNOME is already installed
if ! rpm -q gnome-shell > /dev/null 2>&1; then
    # Install GNOME package
    sudo dnf install -y gnome-shell
fi

# Enable the graphical target
sudo systemctl set-default graphical.target

# Set GNOME as the default desktop GUI for all users
sudo ln -fs /usr/libexec/gdm-x-session /etc/X11/xinit/Xsession

# Enable GDM to start at boot
sudo systemctl enable --now gdm

# Reboot the system
sudo reboot
