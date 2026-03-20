# Dotfiles for Fedora Linux

## Installation

To download the repository use the following command:

    git clone git@github.com:mpetersen/dotfiles_fedora.git && mv dotfiles_fedora .dotfiles

## Setup

The dotfiles are stored in the `repo` directory. To setup your system use the following command:

    ~/.dotfiles/setup.sh

This command will create a link in `~/.bashrc.d` for each file in `repo`.

**WARNING:** It will remove existing dotfiles!

## Private data

Private data must never be committed to Github. In order to avoid this, a new file `exports_private` is created, which should be used to store API keys and other private stuff. This file is excluded from Github (see `.gitignore`).

## Aliases

The `aliases` file provides some useful aliases:

| Alias | Description |
| ----- | ----------- |
| `mkcd` | Creates a directory and also changes the current directory to the new directory. |
| `gitcd` | Checks out a git repository in a standardized directory structure. The `GITROOT` environment variable defines the base directory, where all repositories will be stored. This variable is defined in the `exports` file. Each repository will be created in `$GITROOT/<host, e.g. github.com>/<user, e.g. mpetersen>/<repo, e.g. dotfiles_fedora>` |
| `poddy` | Launches a podman (docker) container in the current directory and links the current directory into the container. This is useful if you want to test without installing an environment on your system. For example `poddy node` runs the NodeJS container. You have write access to the current directory. |
| `la` | Lists the directory including hidden files, shortcut for `ls -la` |
