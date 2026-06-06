#!/usr/bin/env bash
# Methos Linux - archiso profile definition
# Based on official Arch Linux releng profile
# Reference: https://gitlab.archlinux.org/archlinux/archiso/-/blob/master/configs/releng/profiledef.sh

# ===========================================================================
# PROFILE METADATA
# ===========================================================================
profile_name="methos-linux"
iso_label="METHOS_$(date +%Y%m)"
iso_publisher="Methos Linux Project <https://github.com/methos-linux>"
iso_application="Methos Linux Live/Installation System"
iso_volume_id="METHOS_LINUX"
iso_version="$(cat ../VERSION 2>/dev/null || echo '0.1.0-alpha')-$(date +%Y.%m.%d)"
iso_filename="methos-linux-${iso_version}-x86_64.iso"

# ===========================================================================
# BOOT MODES
# ===========================================================================
# GRUB handles both BIOS and UEFI in a single configuration
# NOTE: uefi_arch is set internally by mkarchiso (readonly) - do NOT set it here
boot_modes=(
    "bios+uefi-x64.grub.esp"
)

# ===========================================================================
# FILESYSTEM
# ===========================================================================
airootfs_image_type="squashfs"
airootfs_image_tool_options=(
    "-comp" "zstd"
    "-Xcompression-level" "15"
    "-no-duplicates"
)

# ===========================================================================
# PERMISSIONS
# ===========================================================================
file_permissions=(
    "/etc/shadow:0:0:0400"
    "/etc/gshadow:0:0:0400"
    "/etc/sudoers:0:0:0440"
    "/etc/sudoers.d/10-methos:0:0:0440"
    "/etc/calamares:0:0:755"
    "/etc/calamares/scripts/merge_profiles.sh:0:0:755"
)

# ===========================================================================
# SYMLINKS
# ===========================================================================
file_symlinks=(
    "/usr/bin/sh:bash"
    "/usr/bin/editor:nvim"
)

# ===========================================================================
# ADDITIONAL FILES (on ISO root, relative to profile directory)
# ===========================================================================
files=(
    "README.md"
    "LICENSE"
    "VERSION"
)

# ===========================================================================
# BOOTLOADER SPECIFIC
# ===========================================================================
# EFI GRUB configuration path (relative to profile directory)
uefi_grub_cfg="grub/cfg/grub.cfg"

# BIOS GRUB is automatically detected by mkarchiso