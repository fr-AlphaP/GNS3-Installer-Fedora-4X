# 🌐 GNS3 Management Script for Fedora

This comprehensive Bash script provides a complete solution for managing GNS3 installations on Fedora systems. 
GNS3 is a powerful network simulation tool that allows users to create complex network topologies using both virtual and physical devices. 🖥️🌐

## ✨ Features

- **🎯 Interactive Menu System**: Choose between install, uninstall, clean install, or exit
- **🔄 Complete Installation**: Installs GNS3 and all necessary dependencies automatically  
- **🗑️ Smart Uninstallation**: Safely removes GNS3 with optional dependency cleanup
- **🔧 Clean Install Option**: Uninstall + reinstall in one command
- **🔒 Enhanced Security**: Enforces proper sudo usage (no root direct access, no regular user)
- **🖥️ Desktop Integration**: Creates application shortcut with icon
- **🐳 Docker Support**: Full Docker installation and configuration
- **👤 User-Aware**: Displays personalized welcome messages and handles user permissions correctly
- **🔄 Reboot Management**: Interactive reboot prompts after installation/uninstallation

## 📋 Prerequisites

- **Supported Operating Systems**:

| Versions | Gnome | KDE Plasma | Status |
|----------|-------|------------|--------|
| Fedora 42 | ✅ | ❓ | Tested |
| Fedora 41 | ✅ | ❓ | Tested |
| Fedora 40 | ✅ | ❓ | Compatible |

- Internet access to download necessary packages
- **User account with sudo privileges** (script will verify this automatically)
- **DO NOT run as root directly** - the script enforces sudo usage for security

## 🛠️ Usage Instructions

### 1. **Download the Script**
   ```bash
   # Clone the repository
   git clone https://github.com/fr-AlphaP/GNS3-Installer-Fedora-4X.git
   cd GNS3-Installer-Fedora-4X
   
   # Or download from releases
   wget https://github.com/fr-AlphaP/GNS3-Installer-Fedora-4X/releases/latest/download/GNS3_installer.sh
   ```

### 2. **Make the Script Executable**
   ```bash
   chmod +x GNS3_installer.sh
   ```

### 3. **Run the Script with Sudo**
   ```bash
   sudo ./GNS3_installer.sh
   ```
   
   ⚠️ **Important**: The script MUST be run with `sudo` by a regular user. It will refuse to run if:
   - Executed without sudo (as regular user)
   - Executed directly as root user

### 4. **Choose Your Option**
   The interactive menu will present you with:
   - **[I] Install GNS3**: Fresh installation of GNS3 and dependencies
   - **[C] Clean Install**: Uninstall existing GNS3 then reinstall (recommended for updates)
   - **[U] Uninstall GNS3**: Remove GNS3 with optional dependency cleanup
   - **[E] Exit**: Exit the script

## 📦 What the Script Installs

### 🔧 **Core Dependencies**
- Development tools: `git`, `gcc`, `cmake`, `flex`, `bison`
- Python ecosystem: `python3`, `python3-devel`, `python3-pip`, `python3-PyQt5`, `python3-zmq`
- System libraries: `elfutils-libelf-devel`, `libuuid-devel`, `libpcap-devel`
- Network tools: `wireshark`, `qemu-kvm`, `xterm`, `telnet`, `busybox`, `ubridge`

### 🌐 **GNS3 Components**
- **GNS3 GUI**: Graphical interface (cloned from official repository)
- **GNS3 Server**: Backend server component  
- **Dynamips**: Cisco router emulator (compiled from source)

### 🐳 **Docker Integration**
- Complete Docker CE installation
- Docker Compose and BuildX plugins
- Automatic service enablement
- User permission configuration

### 🖥️ **Desktop Integration**
- Application shortcut in system menu
- GNS3 icon download and setup
- Desktop database updates

## 🗑️ Uninstallation Features

The uninstall option provides granular control:

- **✅ Always Removed**: GNS3 packages, source files, desktop shortcuts, user group memberships
- **❓ Optional Removal** (with user confirmation):
  - Core dependencies (wireshark, qemu-kvm, etc.) - **NOT RECOMMENDED**
  - Docker and related packages - **NOT RECOMMENDED**

## 🔒 Security Features

- **Sudo Enforcement**: Script validates proper sudo usage
- **User Context Preservation**: All user files created with correct ownership
- **Permission Management**: Automatically adds user to required groups (docker, wireshark)
- **Safe Execution**: Prevents execution as root or regular user

## 🚀 Post-Installation

After successful installation:

1. **Reboot recommended** for group permissions to take effect
2. **Launch GNS3**:
   - From desktop menu (Applications → Development → GNS3)
   - From terminal: `gns3`
3. **First-time setup**: Follow GNS3's initial configuration wizard

## 🐛 Troubleshooting

### **Issue: GNS3 GUI elements appear very small**
**Solution**: Add this to your `~/.bashrc`:
```bash
echo 'export QT_SCALE_FACTOR=1.5' >> ~/.bashrc
source ~/.bashrc
```

### **Issue: Permission denied errors**
**Solution**: Ensure you're running with `sudo` and reboot after installation to apply group changes.

### **Issue: Docker commands fail**
**Solution**: Log out and log back in, or reboot to refresh group memberships.

## 📝 Version History

- **v2.0**: Complete rewrite with interactive menu, uninstall functionality, enhanced security
- **v1.1**: Basic installation script

## ⚠️ Disclaimer

This script is **not official** and is **not affiliated with GNS3**. 
You are solely responsible for scripts executed on your machine and their integrity.

## 👨‍💻 Author

**Made by fr-AlphaP** - Student at IUT of Béziers  
⭐ **Don't forget to star this repository if it helped you!**

---

## 📄 License

This project is open source. Feel free to use, modify, and distribute according to your needs.
