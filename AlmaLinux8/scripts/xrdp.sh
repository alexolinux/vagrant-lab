#!/bin/bash

SOURCE_DIR="/usr/local/src"

Dependencies=(
    "install"
    "libtool"
    "openssl-devel"
    "pam-devel"
    "libX11-devel"
    "libXfixes-devel"
    "libXrandr-devel"
    "imlib2-devel"
)

echo -e "2. Installing XRDP Library Deps: \n"

for package in ${Dependencies[@]}; do
    sudo dnf install -y $package
done

dnf --enablerepo=powertools install -y nasm xorg-x11-apps

if [ $? -ne 0 ]; then
    echo -e "Failure to install some package."
else
    echo -e "Compiling XRDP..."
    cd /usr/local/src/
    git clone https://github.com/neutrinolabs/xrdp.git
    cd ${SOURCE_DIR}/xrdp

    source bootstrap
    if [ $? -eq 0 ]; then
        ./configure
        make && make install

        if [ $? -eq 0 ]; then
            echo -e "XRDP is compiled successfully"
            systemctl enable --now xrdp
        else
            echo -e "XRDP is not compiled due to some error."
        fi
    else
        echo -e "There was an error while checking dependencies for XRDP"
    fi
fi

echo -e "Installing extra pakages..."
sudo dnf install -y xorgxrdp

echo -e "Script finished."
