#!/bin/bash
# Methos Linux - ISO Build Script
# Builds the Methos Linux ISO using mkarchiso
# Usage: ./scripts/build.sh [--clean] [--docker]

set -euo pipefail

VERSION="$(cat ../VERSION 2>/dev/null || echo "0.1.0-alpha")"
ISO_DIR="out"
WORK_DIR="work"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

check_deps() {
    command -v mkarchiso >/dev/null 2>&1 || { err "mkarchiso not found. Install archiso."; exit 1; }
    command -v pacman >/dev/null 2>&1 || { err "pacman not found. Build must run on Arch Linux."; exit 1; }
    log "Build dependencies satisfied"
}

clean() {
    warn "Cleaning build artifacts..."
    rm -rf "$ISO_DIR" "$WORK_DIR"
    log "Clean complete"
}

build() {
    log "Building Methos Linux ISO..."
    log "Version: ${VERSION}"
    mkdir -p "$ISO_DIR" "$WORK_DIR"
    mkarchiso -v -w "$WORK_DIR" -o "$ISO_DIR" ./archiso
    log "ISO built: ${ISO_DIR}/methos-linux-*.iso"
}

docker_build() {
    warn "Building in Docker container..."
    docker build -t methos-linux-builder ..
    docker run --rm -v "$(pwd)/..:/build" methos-linux-builder make iso
    log "Docker build complete"
}

main() {
    case "${1:-}" in
        --clean) clean; build ;;
        --docker) docker_build ;;
        --help) echo "Usage: $0 [--clean|--docker|--help]"; exit 0 ;;
        *) check_deps; build ;;
    esac
}

main "$@"