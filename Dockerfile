# Methos Linux ISO Builder
# Build: docker build -t methos-linux-builder .
# Usage: docker run --rm -v $(pwd):/build methos-linux-builder make iso

FROM archlinux:latest AS base

# Install build dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        archiso \
        calamares \
        grub \
        syslinux \
        squashfs-tools \
        libisoburn \
        mtools \
        dosfstools \
        git \
        base-devel \
        python \
        python-pip \
        make \
        && \
    pacman -Scc --noconfirm

# Create working directory
WORKDIR /build

# Copy project files
COPY . .

# Default command
CMD ["make", "iso"]