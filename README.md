# 🐧 Methos Linux

**Arch Linux-based distribution for developers and ethical pentesters.**

## Features

| Feature | Status |
|---------|--------|
| Arch Linux base | ✅ v0.1.0 Alpha |
| Online Installation (latest packages) | ✅ |
| KDE Plasma Desktop | ✅ |
| GRUB Bootloader (BIOS + UEFI) | ✅ |
| Calamares Installer | ✅ |
| 6 Package Profiles | ✅ |
| Multi-profile selection | ✅ |
| GitHub Actions CI/CD | ✅ |
| NVIDIA Support | ✅ |
| Methos AI (skeleton) | 🔜 Beta |

## Package Profiles

| Profile | Focus | Packages |
|---------|-------|----------|
| **Developer** | Git, Docker, VS Code, Python, Node, Go, Rust, Java, GCC, Clang | 90+ |
| **Pentester** | Nmap, Metasploit, Wireshark, SQLMap, FFUF, Nuclei, Ghidra | 120+ |
| **AI Engineer** | PyTorch, TensorFlow, CUDA, JupyterLab, scikit-learn | 100+ |
| **DevOps** | Docker, Podman, K8s Tools, Terraform, Ansible, Prometheus | 130+ |
| **Student** | Firefox, LibreOffice, Obsidian, Telegram, Discord | 80+ |
| **Minimal** | KDE Plasma + Firefox + basic utilities | 40+ |

## Quick Start

```bash
# Clone the project
git clone https://github.com/MethosLinux/methos-linux.git
cd methos-linux

# Build ISO (on Arch Linux)
make iso

# Output: out/methos-linux-*.iso
```

## Architecture

```
mount → unpackfs → packages (online) → machineid → fstab → bootloader → services
```

## 12 Critical Packages

base, linux, linux-firmware, linux-headers, grub, efibootmgr, mkinitcpio, sddm, plasma-meta, networkmanager, sudo, systemd

## License

GNU General Public License v3.0

---

**Project:** [github.com/MethosLinux/methos-linux](https://github.com/MethosLinux/methos-linux)