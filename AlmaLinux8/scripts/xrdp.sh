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
    "fuse-devel"
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
        ./configure \
        --build=x86_64-redhat-linux-gnu \
        --host=x86_64-redhat-linux-gnu \
        --disable-dependency-tracking \
        --prefix=/usr \
        --exec-prefix=/usr \
        --bindir=/usr/bin \
        --sbindir=/usr/sbin \
        --sysconfdir=/etc \
        --datadir=/usr/share \
        --includedir=/usr/include \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/libexec \
        --localstatedir=/var \
        --sharedstatedir=/var/lib \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --enable-fuse \
        --enable-vsock \
        --enable-ipv6 \
        --with-socketdir=/run/xrdp \
        --with-imlib2 build_alias=x86_64-redhat-linux-gnu host_alias=x86_64-redhat-linux-gnu \
        --with-cflags="-O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -fexceptions -fstack-protector-strong -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection" \
        --with-ldflags="-Wl,-z,relro -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld"
        
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
