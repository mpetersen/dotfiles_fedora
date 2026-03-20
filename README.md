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
