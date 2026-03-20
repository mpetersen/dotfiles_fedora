#!/bin/bash
# Bootstrap a new Fedora machine with dotfiles, apps, and GNOME configuration.
# Safe to re-run — skips steps that are already done.
#
# Usage:
#   ./bootstrap.sh           # full setup
#   ./bootstrap.sh --no-gnome  # skip GNOME config restore

set -euo pipefail

BASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# ── Colours ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; RESET='\033[0m'
info()    { echo -e "${GREEN}[bootstrap]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[bootstrap]${RESET} $*"; }
manual()  { echo -e "${RED}[manual]${RESET}    $*"; }

# ── Flags ──────────────────────────────────────────────────────────────────────
RESTORE_GNOME=true
for arg in "$@"; do
    [[ "$arg" == "--no-gnome" ]] && RESTORE_GNOME=false
done

# ── Guards ─────────────────────────────────────────────────────────────────────
if ! grep -q "Fedora" /etc/os-release 2>/dev/null; then
    warn "This script is designed for Fedora. Proceed with caution."
fi

# ── 1. Dotfiles ────────────────────────────────────────────────────────────────
info "Installing dotfiles..."
bash "$BASE_DIR/setup.sh"

# ── 2. DNF packages ────────────────────────────────────────────────────────────
DNF_LIST="$BASE_DIR/packages/dnf.txt"
if [ -f "$DNF_LIST" ]; then
    mapfile -t DNF_PACKAGES < <(grep -v '^\s*#' "$DNF_LIST" | grep -v '^\s*$')
    if [ ${#DNF_PACKAGES[@]} -gt 0 ]; then
        info "Installing DNF packages: ${DNF_PACKAGES[*]}"
        sudo dnf install -y "${DNF_PACKAGES[@]}"
    fi
else
    warn "No DNF package list found at $DNF_LIST, skipping"
fi

# ── 3. Flatpak apps ────────────────────────────────────────────────────────────
FLATPAK_LIST="$BASE_DIR/packages/flatpak.txt"
if [ -f "$FLATPAK_LIST" ]; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    mapfile -t FLATPAK_APPS < <(grep -v '^\s*#' "$FLATPAK_LIST" | grep -v '^\s*$')
    info "Installing Flatpak apps..."
    for app_id in "${FLATPAK_APPS[@]}"; do
        if flatpak list --app --columns=application | grep -q "^${app_id}$"; then
            info "  $app_id — already installed, skipping"
        else
            info "  Installing $app_id..."
            flatpak install -y flathub "$app_id"
        fi
    done
else
    warn "No Flatpak app list found at $FLATPAK_LIST, skipping"
fi

# ── 5. Claude Code ─────────────────────────────────────────────────────────────
if ! command -v claude &>/dev/null; then
    info "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    info "Claude Code — already installed, skipping"
fi

# ── 6. Code directory ──────────────────────────────────────────────────────────
GITROOT="${GITROOT:-$HOME/Code}"
if [ ! -d "$GITROOT" ]; then
    info "Creating code directory at $GITROOT..."
    mkdir -p "$GITROOT"
fi

# ── 7. GNOME configuration ─────────────────────────────────────────────────────
GNOME_CONFIG="$BASE_DIR/config/gnome_config.txt"
if $RESTORE_GNOME && [ -f "$GNOME_CONFIG" ]; then
    info "Restoring GNOME configuration..."
    dconf load / < "$GNOME_CONFIG"
    info "GNOME config restored. You may need to log out and back in."
elif ! $RESTORE_GNOME; then
    warn "Skipping GNOME config restore (--no-gnome)"
else
    warn "No GNOME config found at $GNOME_CONFIG, skipping"
fi

# ── 8. Manual steps reminder ───────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Remaining manual steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
manual "JetBrains Toolbox — download from https://www.jetbrains.com/toolbox-app"
manual "  then install IntelliJ IDEA through Toolbox"
manual "Topbar Weather extension — https://extensions.gnome.org/extension/9123/topbar-weather/"
manual "Flatseal — grant Chrome access to ~/.local/share/applications and ~/.local/share/icons"
manual "  (needed for Lightroom, Spotify, Sonos web apps)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
info "Bootstrap complete."
