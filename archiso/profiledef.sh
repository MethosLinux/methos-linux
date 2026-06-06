#!/usr/bin/env bash
# Minimal profile matching Arch releng exactly

profile_name="methos-linux"
iso_label="METHOS_$(date +%Y%m)"
iso_publisher="Methos Linux Project <https://github.com/methos-linux>"
iso_application="Methos Linux Live/Installation System"
iso_volume_id="METHOS_LINUX"
install_dir="arch"
buildmodes=('iso')
bootmodes=('uefi-x64.systemd-boot.esp')
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd')
pacman_conf="pacman.conf"