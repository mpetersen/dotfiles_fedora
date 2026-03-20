#!/bin/bash
# Install Broadcom WiFi drivers on Fedora (e.g. Intel MacBook Pro).
# See docs/install_wifi.md for background.

set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
info() { echo -e "${GREEN}[wifi]${RESET} $*"; }
warn() { echo -e "${YELLOW}[wifi]${RESET} $*"; }

# ── 1. Detect Broadcom device ──────────────────────────────────────────────────
info "Checking for Broadcom WiFi chipset..."
if ! lspci -nn | grep -i broadcom; then
    warn "No Broadcom device detected. This script may not be needed on this machine."
    read -rp "Continue anyway? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
fi

# ── 2. Enable RPM Fusion repositories ─────────────────────────────────────────
info "Enabling RPM Fusion free and nonfree repositories..."
FEDORA_VER=$(rpm -E %fedora)
sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VER}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VER}.noarch.rpm"

# ── 3. Update package metadata ─────────────────────────────────────────────────
info "Refreshing package metadata..."
sudo dnf upgrade -y --refresh

# ── 4. Install build tools and kernel headers ──────────────────────────────────
info "Installing build tools and kernel headers..."
sudo dnf install -y akmods "kernel-devel-uname-r == $(uname -r)"
sudo dnf install -y @development-tools

# ── 5. Install driver package ──────────────────────────────────────────────────
info "Installing broadcom-wl driver..."
sudo dnf install -y broadcom-wl

# ── 6. Build kernel module ─────────────────────────────────────────────────────
info "Building kernel module (this may take a few minutes)..."
sudo akmods --force

# ── 7. Reboot ──────────────────────────────────────────────────────────────────
info "Done. A reboot is required to load the driver."
read -rp "Reboot now? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] && sudo reboot
