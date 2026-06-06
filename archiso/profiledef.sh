#!/usr/bin/env bash
# Methos Linux - archiso profile definition
# GRUB-only boot configuration (supports BIOS + UEFI)

profile_name="methos-linux"
iso_label="METHOS_$(date +%Y%m)"
iso_publisher="Methos Linux Project <https://github.com/methos-linux>"
iso_application="Methos Linux Live/Installation System"
iso_volume_id="METHOS_LINUX"
iso_version="$(cat ../VERSION 2>/dev/null || echo '0.1.0-alpha')-$(date +%Y.%m.%d)"
iso_filename="methos-linux-${iso_version}-x86_64.iso"

# Single boot mode: GRUB handles both BIOS and UEFI
boot_modes=(
    "bios+uefi-x64.grub.esp"
)

bootloader="grub"
uefi_arch="x86_64"

# Filesystem
airootfs_image_type="squashfs"
airootfs_image_tool_options=(
    "-comp" "zstd"
    "-Xcompression-level" "15"
    "-no-duplicates"
)

# Permissions
file_permissions=(
    "/etc/shadow:0:0:0400"
    "/etc/gshadow:0:0:0400"
    "/etc/sudoers:0:0:0440"
    "/etc/sudoers.d/10-methos:0:0:0440"
    "/etc/calamares:0:0:755"
    "/etc/calamares/scripts/merge_profiles.sh:0:0:755"
)

# Symlinks
file_symlinks=(
    "/usr/bin/sh:bash"
    "/usr/bin/editor:nvim"
)

# Additional files
files=(
    "../README.md"
    "../LICENSE"
    "../VERSION"
)

uefi_grub_cfg="grub/cfg/grub.cfg"