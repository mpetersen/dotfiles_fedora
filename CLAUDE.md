# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Dotfiles and machine setup scripts for Fedora Linux with a GNOME desktop (primarily used on Intel MacBooks).

## Key scripts

| Script | Purpose |
|--------|---------|
| `bootstrap.sh` | Full machine setup — run once on a new machine |
| `setup.sh` | Dotfiles only — symlinks `repo/*` into `~/.bashrc.d/` |
| `install_wifi.sh` | Broadcom WiFi driver setup (Intel MacBook on Fedora) |

## Structure

- `repo/` — bash files sourced via `~/.bashrc.d/`. Every file here gets symlinked by `setup.sh`.
- `packages/dnf.txt` and `packages/flatpak.txt` — package lists read by `bootstrap.sh`. One entry per line, `#` comments supported.
- `config/gnome_config.txt` — GNOME settings snapshot, created via `dconf dump /` and restored via `dconf load /`.
- `docs/` — human-readable setup guides (WiFi, app list, config backup).

## GNOME config backup

```bash
cd ~/.dotfiles && \
  dconf dump / > config/gnome_config.txt && \
  git add config/gnome_config.txt && \
  git commit -m "GNOME configuration backup $(date +"%Y-%m-%d %H:%M:%S")" && \
  git push && \
  cd -
```

## Private data

`repo/exports_private` is git-ignored and created empty by `setup.sh` on first run. Use it for API keys and secrets — never commit it.
