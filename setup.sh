#!/bin/bash

base_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
target_dir=~/.bashrc.d

# Ensure target dir exists
mkdir -p $target_dir

# Install dotfiles
for dotfile in $base_dir/repo/* ; do
    name=$(basename $dotfile)
    target=$target_dir/$name
    rm -f $target
    ln -sv $base_dir/repo/$name $target
done
