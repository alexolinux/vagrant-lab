#!/bin/bash

Dependencies=(
    "install"
    "libtool"
    "openssl-devel"
    "pam-devel"
    "libX11-devel"
    "libXfixes-devel"
    "libXrandr-devel"
)

echo -e "2. Installing XRDP Library Deps: \n"

for package in ${Packages[@]}; do
    sudo dnf install -y $package
done

dnf --enablerepo=powertools install -y nasm

if [ $? -ne 0 ]; then
    echo -e "Failure to install some package."
else
    echo -e "Compiling XRDP..."
    cd /usr/local/src/
    git clone https://github.com/neutrinolabs/xrdp.git
    cd xrdp
    ./configure
    make && make install

    if [ $? -eq 0 ]; then
        echo -e "XRDP is compiled successfully"
        systemctl enable --now xrdp
    else
        echo -e "XRDP is not compiled due to some error."
    fi
fi

echo -e "Script finished."
