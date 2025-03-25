#!/bin/bash

install() {
    echo "Installation en cours..."
    sudo dnf -y install git gcc cmake flex bison python3 python3-devel python3-pip \
        python3-setuptools python3-PyQt5 python3-zmq elfutils-libelf-devel libuuid-devel \
        libpcap-devel wireshark qemu-kvm
    mkdir -p ~/.GNS3
    cd ~/.GNS3
    git clone https://github.com/GNS3/gns3-gui.git
    git clone https://github.com/GNS3/gns3-server.git
    cd gns3-gui
    sudo python3 setup.py install
    cd ..
    cd gns3-server
    sudo python3 setup.py install
    # Dynamips
    cd ~/.GNS3
    git clone https://github.com/GNS3/dynamips.git
    cd dynamips
    mkdir build
    cd build
    cmake ..
    make
    sudo make install
    sudo dnf install xterm telnet
}


if [ "$EUID" -ne 0 ]; then
    echo "The script requires administrator privileges to install GNS3 and its dependencies."
    echo "Execute sudo !!"
    exit 1
else
    install
fi
