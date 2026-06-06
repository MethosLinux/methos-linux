# Installing Methos Linux

## Prerequisites

- 2GB RAM minimum (4GB recommended)
- 20GB disk space minimum (50GB recommended)
- Stable internet connection (online installation)
- USB drive (4GB+) or DVD for boot media

## Installation Steps

### 1. Create Bootable USB

```bash
# Linux
sudo dd if=methos-linux-*.iso of=/dev/sdX bs=4M status=progress

# Windows
# Use Rufus or balenaEtcher
```

### 2. Boot from USB

1. Insert USB and restart
2. Enter boot menu (F12, F2, Del depending on hardware)
3. Select USB drive
4. GRUB menu appears → "Boot Methos Linux (Live System)"

### 3. Run Calamares Installer

Once in the live desktop:
1. Double-click "Install Methos Linux"
2. Select language → Click Next
3. Select timezone → Click Next
4. Select keyboard layout → Click Next
5. Select disk and partitioning → Click Next
6. Create user account → Click Next
7. Review summary → Click Install

### 4. Online Installation

The installer will:
1. Extract base system
2. Download packages from Arch repositories
3. Install selected profiles
4. Configure GRUB bootloader
5. Complete setup

### 5. First Boot

After restart:
1. Boot into GRUB → select "Methos Linux"
2. Login with the user created during installation
3. KDE Plasma Desktop loads
4. Open terminal: `sudo pacman -Syu` to update

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Black screen on boot | Select "nomodeset" from GRUB |
| No internet | Check NetworkManager in system tray |
| Installation fails | Check /var/log/methos-install.log |