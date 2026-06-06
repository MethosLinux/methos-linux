#!/usr/bin/make -f
# Methos Linux Build System
# Usage: make <target>

SHELL := /bin/bash
.PHONY: all build clean prepare iso calamares test help

# Project metadata
PROJECT := methos-linux
VERSION := $(shell cat VERSION 2>/dev/null || echo "0.1.0-alpha")
DATE := $(shell date +%Y.%m.%d)
ARCH := x86_64
ISO_NAME := $(PROJECT)-$(VERSION)-$(DATE)-$(ARCH).iso
ISO_DIR := out
WORK_DIR := work

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default target
all: prepare iso

# Help target
help:
	@echo "$(GREEN)Methos Linux Build System$(NC)"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Prepare and build ISO (default)"
	@echo "  prepare   - Check dependencies and prepare build environment"
	@echo "  iso       - Build the ISO image using mkarchiso"
	@echo "  clean     - Remove build artifacts"
	@echo "  distclean - Remove everything including work directory"
	@echo "  test      - Run tests"
	@echo "  validate  - Validate configuration files"
	@echo "  setup     - Setup development environment"
	@echo "  docker    - Build ISO inside Docker container"
	@echo ""
	@echo "Variables:"
	@echo "  VERSION=$(VERSION)  - Override version"
	@echo "  ISO_DIR=$(ISO_DIR)  - Output directory"

# Prepare build environment
prepare:
	@echo "$(YELLOW)[*] Checking build dependencies...$(NC)"
	@command -v mkarchiso >/dev/null 2>&1 || { \
		echo "$(RED)[!] mkarchiso not found. Install archiso package.$(NC)"; \
		exit 1; \
	}
	@command -v pacman >/dev/null 2>&1 || { \
		echo "$(RED)[!] pacman not found. This build must run on Arch Linux.$(NC)"; \
		exit 1; \
	}
	@echo "$(GREEN)[✓] Build dependencies satisfied$(NC)"
	@mkdir -p $(ISO_DIR)
	@echo "$(GREEN)[✓] Build environment ready$(NC)"

# Build ISO
iso: prepare
	@echo "$(YELLOW)[*] Building Methos Linux ISO...$(NC)"
	@echo "$(YELLOW)[*] ISO Name: $(ISO_NAME)$(NC)"
	@echo "$(YELLOW)[*] Version: $(VERSION) | Date: $(DATE)$(NC)"
	@mkdir -p $(ISO_DIR) $(WORK_DIR)
	@mkarchiso -v -w $(WORK_DIR) -o $(ISO_DIR) ./archiso
	@echo "$(GREEN)[✓] ISO built successfully: $(ISO_DIR)/$(ISO_NAME)$(NC)"

# Validate configuration files
validate:
	@echo "$(YELLOW)[*] Validating configuration files...$(NC)"
	@ERRORS=0; \
	for f in archiso/profiledef.sh archiso/pacman.conf archiso/mkinitcpio.conf; do \
		if [ ! -f "$$f" ]; then \
			echo "$(RED)[!] Missing: $$f$(NC)"; \
			ERRORS=$$((ERRORS + 1)); \
		else \
			echo "$(GREEN)[✓] Found: $$f$(NC)"; \
		fi; \
	done; \
	for f in archiso/profiles/*.pkgs; do \
		if [ ! -f "$$f" ]; then \
			echo "$(RED)[!] Missing package profile: $$f$(NC)"; \
			ERRORS=$$((ERRORS + 1)); \
		fi; \
	done; \
	if [ $$ERRORS -gt 0 ]; then \
		echo "$(RED)[!] $$ERRORS validation errors found$(NC)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)[✓] All files validated successfully$(NC)"

# Clean build artifacts
clean:
	@echo "$(YELLOW)[*] Cleaning build artifacts...$(NC)"
	@rm -rf $(ISO_DIR)
	@echo "$(GREEN)[✓] Clean complete$(NC)"

# Full clean including work directory
distclean: clean
	@echo "$(YELLOW)[*] Deep cleaning...$(NC)"
	@rm -rf $(WORK_DIR)
	@rm -f *.iso *.iso.sig *.iso.zsync
	@echo "$(GREEN)[✓] Deep clean complete$(NC)"

# Run tests
test: validate
	@echo "$(YELLOW)[*] Running tests...$(NC)"
	@for test in tests/*.sh; do \
		if [ -x "$$test" ]; then \
			echo "$(YELLOW)[*] Running: $$test$(NC)"; \
			"$$test" || exit 1; \
		fi; \
	done
	@echo "$(GREEN)[✓] All tests passed$(NC)"

# Setup development environment
setup:
	@echo "$(YELLOW)[*] Setting up development environment...$(NC)"
	@echo "This script will install required packages for building Methos Linux."
	@echo "It must be run on Arch Linux with sudo privileges."
	@read -p "Continue? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		sudo pacman -S --needed --noconfirm archiso calamares calamares-config \
			grub syslinux squashfs-tools libisoburn mtools dosfstools \
			git base-devel python python-pip; \
		echo "$(GREEN)[✓] Development environment ready$(NC)"; \
	else \
		echo "Setup cancelled."; \
	fi

# Build ISO in Docker container (for non-Arch hosts)
docker:
	@echo "$(YELLOW)[*] Building ISO in Docker container...$(NC)"
	@docker build -t methos-linux-builder .
	@docker run --rm -v "$(PWD):/build" methos-linux-builder make iso
	@echo "$(GREEN)[✓] Docker build complete$(NC)"

# Create a release (version tag + build)
release:
	@echo "$(YELLOW)[*] Creating release $(VERSION)...$(NC)"
	@git tag -a "v$(VERSION)" -m "Methos Linux $(VERSION)"
	@git push origin "v$(VERSION)"
	@echo "$(GREEN)[✓] Release $(VERSION) tagged$(NC)"