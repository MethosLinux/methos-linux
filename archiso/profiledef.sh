#!/usr/bin/env bash
# shellcheck disable=SC2034
# Methos Linux - archiso profile definition
# Compatible with mkarchiso v80+
# NOTE: bootmodes (no underscore) is the correct variable name in modern mkarchiso

profile_name="methos-linux"
iso_label="METHOS_$(date +%Y%m)"
iso_publisher="Methos Linux Project <https://github.com/methos-linux>"
iso_application="Methos Linux Live/Installation System"
iso_volume_id="METHOS_LINUX"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.grub.mbr' 'uefi-x64.systemd-boot.esp')
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd')
pacman_conf="pacman.conf"