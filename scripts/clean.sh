#!/bin/bash
# Methos Linux - Clean Script
set -euo pipefail

rm -rf out work *.iso *.iso.sig *.iso.zsync
echo "Cleaned build artifacts."