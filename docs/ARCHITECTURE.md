# Methos Linux Architecture

## Overview

Methos Linux is an Arch Linux-based distribution designed for developers and ethical pentesters.

## Core Design Decisions

### Bootloader: GRUB only
- Single bootloader handles both BIOS and UEFI
- Simplified from 3 bootloaders (GRUB + Syslinux + systemd-boot) to GRUB only

### Installation: Online
- Base system extracted from squashfs (unpackfs)
- All packages fetched live from official Arch repositories
- No AUR or external repositories in Alpha

### Profiles: Multi-select with conflict resolution
- 6 profiles: Developer, Pentester, AI Engineer, DevOps, Student, Minimal
- Multiple profiles can be selected simultaneously
- Conflicts resolved via single-pass fallback mapping

## Calamares Workflow (Official Order)

```
mount → unpackfs → packages → machineid → fstab → bootloader → services
```

## Critical Packages (12 items)

| Package | Purpose |
|---------|---------|
| base | Core Arch Linux system |
| linux | Linux kernel |
| linux-firmware | Hardware firmware |
| linux-headers | Kernel headers |
| grub | Bootloader (BIOS+UEFI) |
| efibootmgr | EFI boot entries |
| mkinitcpio | Initramfs generator |
| sddm | Display manager |
| plasma-meta | KDE Plasma desktop |
| networkmanager | Network management |
| sudo | Privilege escalation |
| systemd | Init system |

## Conflict Resolution Strategy

Single-pass rule-based resolution:
1. Every conflicting package has a fallback mapping
2. All occurrences replaced by the fallback
3. No recursion, no retries, no re-evaluation
4. First valid package wins deterministically

## Boot Guarantee

Best-effort with recovery logging enabled.
If critical packages are missing, installation halts with clear error.