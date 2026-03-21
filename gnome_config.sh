#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

DCONF_PATHS=(
    "/org/gnome/desktop/app-folders/"
    "/org/gnome/desktop/background/"
    "/org/gnome/desktop/break-reminders/"
    "/org/gnome/desktop/calendar/"
    "/org/gnome/desktop/datetime/"
    "/org/gnome/desktop/input-sources/"
    "/org/gnome/desktop/interface/"
    "/org/gnome/desktop/peripherals/"
    "/org/gnome/desktop/privacy/"
    "/org/gnome/desktop/search-providers/"
    "/org/gnome/desktop/sound/"
    "/org/gnome/desktop/wm/"
    "/org/gnome/Ptyxis/"
    "/org/gnome/nautilus/preferences/"
    "/org/gnome/settings-daemon/plugins/color/"
    "/org/gnome/settings-daemon/plugins/media-keys/"
    "/org/gnome/shell/"
    "/org/gnome/system/location/"
    "/org/gnome/tweaks/"
    "/system/locale/"
)

STRIP_KEYS=(
    "night-light-last-coordinates"
)

backup() {
    for path in "${DCONF_PATHS[@]}"; do
        local dump
        dump=$(dconf dump "$path")
        [[ -z "${dump//[$'\n' ]/}" ]] && continue
        for key in "${STRIP_KEYS[@]}"; do
            dump=$(printf '%s\n' "$dump" | grep -v "^${key}=")
        done
        printf '%s\n' "$dump" > "$CONFIG_DIR/dconf${path//\//_}.config"
    done
}

restore() {
    for path in "${DCONF_PATHS[@]}"; do
        local file="$CONFIG_DIR/dconf${path//\//_}.config"
        [[ -f "$file" ]] && dconf load "$path" < "$file"
    done
}

case "${1:-}" in
    backup)  backup ;;
    restore) restore ;;
    *)
        echo "Usage: $0 {backup|restore}" >&2
        exit 1
        ;;
esac
