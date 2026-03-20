# Dotfiles for Fedora Linux

## Installation

To download the repository use the following command:

    git clone git@github.com:mpetersen/dotfiles_fedora.git && mv dotfiles_fedora ~/.dotfiles

## WiFi (Intel MacBook)

On an Intel MacBook, Fedora does not include Broadcom WiFi drivers out of the box. To install them:

    ~/.dotfiles/install_wifi.sh

See `docs/install_wifi.md` for details.

## Bootstrap (new machine)

To fully set up a new machine — dotfiles, apps, and GNOME configuration — run:

    ~/.dotfiles/bootstrap.sh

This installs DNF packages, Flatpak apps, Google Chrome, Claude Code, restores GNOME settings, and symlinks the dotfiles. Safe to re-run.

To skip restoring GNOME settings:

    ~/.dotfiles/bootstrap.sh --no-gnome

## Dotfiles only

To only install the dotfiles (symlinks into `~/.bashrc.d`):

    ~/.dotfiles/setup.sh

> **WARNING:** It will remove existing dotfiles!

## Private data

Private data must never be committed to Github. In order to avoid this, a new file `exports_private` is created, which should be used to store API keys and other private stuff. This file is excluded from Github (see `.gitignore`).

## Aliases

The `aliases` file provides some useful aliases:

| Alias | Description |
| ----- | ----------- |
| `mkcd` | Creates a directory and also changes the current directory to the new directory. |
| `gitcd` | Checks out a git repository in a standardized directory structure. The `GITROOT` environment variable defines the base directory, where all repositories will be stored. This variable is defined in the `exports` file. Each repository will be created in `$GITROOT/<host, e.g. github.com>/<user, e.g. mpetersen>/<repo, e.g. dotfiles_fedora>`. <br/><br/>Usage: `gitcd <repo_url>`. The URL can be a HTTPS or SSH URL. Example: `gitcd git@github.com:mpetersen/dotfiles_fedora.git` will clone the repository into `$GITROOT/github.com/mpetersen/dotfiles_fedora`. <br/><br/>If the directory already exists, it will simply change into the directory. |
| `poddy` | Launches a Podman (Docker) container in the current directory and links the current directory into the container. This is useful if you want to test without installing an environment on your system. <br/><br/>For example `poddy node` runs the NodeJS container. You have write access to the current directory. |
| `la` | Lists the directory including hidden files, shortcut for `ls -la` |
