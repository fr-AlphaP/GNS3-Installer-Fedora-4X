#!/bin/bash

install() {
    echo "Installation in progress..."
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
    make install

    dnf install xterm telnet

    dnf install busybox
    sudo dnf -y install dnf-plugins-core
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo docker run hello-world
    sudo usermod -aG docker $USER
    sudo usermod -aG wireshark $USER
    docker pull registry.iutbeziers.fr/debianiut:latest
    docker images

    cd /home/"$ORIGINAL_USER"/.local/share/applications/
    wget https://raw.githubusercontent.com/AlphaProxi/GNS3-Installer-Fedora-4X/main/gns3.png
    echo "[Desktop Entry]
    Name=GNS3
    Exec=gns3
    Type=Application
    Icon=/home/"$ORIGINAL_USER"/.local/share/applications/gns3.png
    Comment=GNS3
    Categories=Development;Network;
    Terminal=false" > /home/"$ORIGINAL_USER"/.local/share/applications/gns3.desktop
    chmod +x /home/"$ORIGINAL_USER"/.local/share/applications/gns3.desktop
    update-desktop-database /home/"$ORIGINAL_USER"/.local/share/applications/
    echo -e "\n\n\n"
    echo "Script version : 1.1 - 09/04/2025"
    echo "Installation successful. Thanks for using my script. Don't forget to star it on GitHub!"
    echo "Made by AlphaP, Student at IUT of Béziers"
    echo -e "\n\n\n"
          
}

if [ "$EUID" -ne 0 ]; then
    echo "The script requires administrator privileges to install GNS3 and its dependencies."
    echo "Execute sudo !!"
    exit 1
else
    ORIGINAL_USER=${SUDO_USER:-$USER}
    install
fi
