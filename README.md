# 🌐 Automatic GNS3 Installation Script for Fedora (4X)

This Bash script automates the installation of GNS3 on Fedora 41 and 42 systems. 
GNS3 is a powerful tool for network simulation, allowing users to create complex network topologies using both virtual and physical devices. 🖥️🌐

## ✨ Features

- **Automatic Installation**: Installs GNS3 and all its necessary dependencies.
- **Compatibility**: Tested on Fedora 41 and Fedora 42 (I haven't tested other versions).
- **Ease of Use**: No manual configuration required.

## 📋 Prerequisites

- Fedora 41 or 42 operating system.
- Gnome 47 ✅
- Internet access to download necessary packages.
- **Administrative privileges to run the script.**

## 🛠️ Usage Instructions

1. **Download the Script**:
   - Clone this repository to your Fedora machine.
   - Or download it here : [GNS3-Installer-Fedora-4X Releases](https://github.com/AlphaProxi/GNS3-Installer-Fedora-4X/releases)

2. **Make the Script Executable**:
   - Open a terminal and navigate to the directory containing the script.
   - Run the following command to make the script executable:
     
     ```bash
     chmod +x script.sh
     ```

3. **Run the Script**:
   - Execute the script with administrative privileges:
     
     ```bash
     sudo ./script.sh
     ```

4. **Follow the Instructions**:
   - The script will automatically download and install GNS3 and all its dependencies.
   - Once the installation is complete, you can launch GNS3 in the terminal by typing "gns3server" and "gns3"
     
## 📦 Script Contents

- **Dependency Installation**: Uses `dnf` to install necessary packages like `git`, `gcc`, `python3`, etc.
- **GNS3 Repository Cloning**: Downloads GUI and server components of GNS3 from GitHub.
- **Dynamips Installation**: Compiles and installs Dynamips, a Cisco router emulator used by GNS3.
- **Installation of xterm and telnet**: For  compatibility with GNS3 consoles.

## 📝 Notes

- Soon, I will upload the uninstallation script.
- Have a great time using it!
