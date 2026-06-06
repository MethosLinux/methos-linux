#!/usr/bin/env bash
# Methos Linux - archiso profile definition
# This file is sourced by mkarchiso, not executed
# Variables are read by mkarchiso internally

profile_name="methos-linux"

iso_label="METHOS_$(date +%Y%m)"
iso_publisher="Methos Linux Project <https://github.com/methos-linux>"
iso_application="Methos Linux Live/Installation System"
iso_volume_id="METHOS_LINUX"
iso_version="$(date +%Y.%m.%d)"
iso_filename="methos-linux-x86_64.iso"

install_dir="arch"
buildmodes=('iso')
boot_modes=('bios.grub.mbr' 'uefi-x64.systemd-boot.esp')

airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd')