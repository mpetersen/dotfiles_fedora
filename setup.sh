#!/bin/bash

base_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
target_dir=~/.bashrc.d

# Create a file for private data
[ -f $base_dir/repo/exports_private ] || touch $base_dir/repo/exports_private

# Install git hooks
cp $base_dir/hooks/pre-commit $base_dir/.git/hooks/pre-commit
chmod +x $base_dir/.git/hooks/pre-commit

# Ensure target dir exists
mkdir -p $target_dir

# Install dotfiles
for dotfile in $base_dir/repo/* ; do
    name=$(basename $dotfile)
    target=$target_dir/$name
    rm -f $target
    ln -sv $base_dir/repo/$name $target
done
