#!/bin/bash

install() {
    local USER_HOME="/home/$SUDO_USER"
    local GNS3_SOURCES_DIR="$USER_HOME/.GNS3"
    echo "Installing GNS3 dependencies..."

    dnf -y install git gcc cmake flex bison python3 python3-devel python3-pip \
        python3-setuptools python3-PyQt5 python3-zmq elfutils-libelf-devel libuuid-devel \
        libpcap-devel wireshark qemu-kvm xterm telnet busybox ubridge

    echo "Installing GNS3 via Python packages..."
    sudo -u "$SUDO_USER" mkdir -p "$GNS3_SOURCES_DIR"
    sudo -u "$SUDO_USER" git clone https://github.com/GNS3/gns3-gui.git "$GNS3_SOURCES_DIR/gns3-gui" --depth 1
    sudo -u "$SUDO_USER" git clone https://github.com/GNS3/gns3-server.git "$GNS3_SOURCES_DIR/gns3-server" --depth 1
    cd "$GNS3_SOURCES_DIR/gns3-gui" && python3 setup.py install
    cd "$GNS3_SOURCES_DIR/gns3-server" && python3 setup.py install

    echo "Dynamips installation..."
    sudo -u "$SUDO_USER" git clone https://github.com/GNS3/dynamips.git "$GNS3_SOURCES_DIR/dynamips" --depth 1
    cd "$GNS3_SOURCES_DIR/dynamips"
    sudo -u "$SUDO_USER" mkdir -p build && cd build
    sudo -u "$SUDO_USER" cmake ..
    sudo -u "$SUDO_USER" make
    sudo make install 

    echo "Docker installation..."
    dnf -y install dnf-plugins-core
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker
    docker run --rm hello-world

    usermod -aG docker,wireshark "$SUDO_USER"

    echo "Shortcut creation..."
    local APP_DIR="$USER_HOME/.local/share/applications"
    local ICON_PATH="$APP_DIR/gns3.png"
    sudo -u "$SUDO_USER" mkdir -p "$APP_DIR"
    sudo -u "$SUDO_USER" wget -O "$ICON_PATH" "https://github.com/fr-AlphaP/GNS3-Installer-Fedora-4X/blob/main/gns3.png"
    sudo -u "$SUDO_USER" tee "$APP_DIR/gns3.desktop" > /dev/null <<EOF
[Desktop Entry]
Name=GNS3
Exec=/usr/local/bin/gns3
Type=Application
Icon=$ICON_PATH
Comment=GNS3 Graphical Network Simulator
Categories=Development;Network;
Terminal=false
EOF
    sudo -u "$SUDO_USER" chmod +x "$APP_DIR/gns3.desktop"
    sudo -u "$SUDO_USER" update-desktop-database "$APP_DIR"

    echo "GNS3 installation completed."
    echo "You have to reboot your system to apply changes."
    read -p "Do you want to reboot now? (y/n): " reboot_choice
    if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
        echo "Rebooting now..."
        reboot
    else
        echo "You can reboot later to apply changes."
        exit 0
    fi
}

uninstall() {
    local USER_HOME="/home/$SUDO_USER"
    local GNS3_SOURCES_DIR="$USER_HOME/.GNS3"
    local APP_DIR="$USER_HOME/.local/share/applications"
    local ICON_PATH="$APP_DIR/gns3.png"
    local GNS3_DESKTOP_FILE="$APP_DIR/gns3.desktop"

    echo "Uninstalling GNS3..."

    # 1) Removing GNS3 Python packages
    echo "Uninstalling GNS3 Python packages..."
    pip3 uninstall -y gns3-gui gns3-server
    if [ -d "$GNS3_SOURCES_DIR/gns3-gui" ]; then
        echo "Removing GNS3 GUI source directory..."
        rm -rf "$GNS3_SOURCES_DIR/gns3-gui"
    fi
    if [ -d "$GNS3_SOURCES_DIR/gns3-server" ]; then
        echo "Removing GNS3 Server source directory..."
        rm -rf "$GNS3_SOURCES_DIR/gns3-server"
    fi

    # 2) Removing Dynamips
    echo "Uninstalling Dynamips..."
    if [ -d "$GNS3_SOURCES_DIR/dynamips" ]; then
        cd "$GNS3_SOURCES_DIR/dynamips/build" 2>/dev/null && make uninstall 2>/dev/null
        rm -rf "$GNS3_SOURCES_DIR/dynamips"
    fi

    # 3) Removing shortcut and icon
    echo "Removing GNS3 shortcut and icon..."
    if [ -f "$GNS3_DESKTOP_FILE" ]; then
        sudo -u "$SUDO_USER" rm -f "$GNS3_DESKTOP_FILE"
    fi
    if [ -f "$ICON_PATH" ]; then
        sudo -u "$SUDO_USER" rm -f "$ICON_PATH"
    fi
    sudo -u "$SUDO_USER" update-desktop-database "$APP_DIR" 2>/dev/null

    # 4) Removing GNS3 source directories
    if [ -d "$GNS3_SOURCES_DIR" ]; then
        echo "Removing GNS3 source directory..."
        sudo -u "$SUDO_USER" rm -rf "$GNS3_SOURCES_DIR"
    fi


    read -p "Do you want to remove core GNS3 dependencies (e.g., wireshark, qemu-kvm, etc.)? -> NOT RECOMMENDED (y/n): " remove_deps_choice
    if [[ "$remove_deps_choice" =~ ^[Yy]$ ]]; then
        echo "Removing GNS3 core dependencies..."
        dnf -y remove wireshark qemu-kvm xterm telnet busybox ubridge
    fi

    read -p "Do you want to remove Docker and its related packages? -> NOT RECOMMENDED (y/n): " remove_docker_choice
    if [[ "$remove_docker_choice" =~ ^[Yy]$ ]]; then
        echo "Removing Docker..."
        systemctl disable --now docker
        dnf -y remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        dnf config-manager --disable docker-ce.repo
        rm -rf /var/lib/docker
        rm -rf /etc/docker
    fi

    # 7) Removing $SUDO_USER from docker and wireshark groups
    echo "Removing $SUDO_USER from docker and wireshark groups..."
    gpasswd -d "$SUDO_USER" docker 2>/dev/null
    gpasswd -d "$SUDO_USER" wireshark 2>/dev/null

    echo "GNS3 uninstallation completed."
    echo "You might need to reboot your system for all changes to take effect, especially group memberships."
    read -p "Do you want to reboot now? (y/n): " reboot_choice
    if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
        echo "Rebooting now..."
        reboot
    else
        echo "You can reboot later to apply changes."
        exit 0
    fi
}

clean_install() {
    uninstall
    install
}

main_menu() {
    echo " "
    echo "Welcome $SUDO_USER to fr-AlphaP's script to manage GNS3"
    echo " "
    echo -e "This script is not official and is in no way affiliated with GNS3. \nYou are solely responsible for the scripts executed on your machine and for their integrity."
    echo " "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " [I] Install GNS3"
    echo " [C] Clean install (uninstall + install)"
    echo " [U] Uninstall GNS3"
    echo " [E] Exit"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " "
    read -p "What is your choice ? " choice

    case $choice in
        [Ii]* ) install ;;
        [Cc]* ) clean_install ;;
        [Uu]* ) uninstall ;;
        [Ee]* ) echo "Goodbye!"; exit 0 ;;
        * ) echo "Invalid choice."; exit 1 ;;
    esac
}


# Function to check if the script is run with sudo privileges (and not root btw)

check_sudo() {
    if [ -z "$SUDO_USER" ] || [ "$EUID" -ne 0 ]; then
        echo "❌ Error: This script must be run with sudo by a standard user."
        echo "   Usage: sudo $0"
        exit 1
    fi
}

# Function calls
check_sudo
main_menu
