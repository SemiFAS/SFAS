#!/bin/bash

# This script will install gnulib

# Full script path
script_path=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`

# This directory path
dir=`dirname "${script_path}"`

dir_external="${dir}/../external"
dir_install="${dir_external}/gnulib"

# Nothing to be done
if [ -d "$dir_install" ]; then
    exit 0
fi

mkdir -p $dir_external
mkdir -p $dir_install
this_dir=`pwd`
cd $dir_install
path=`pwd`
cd $dir/../submodules/glib
meson _build --prefix=$path --optimization=3 --buildtype=release
ninja -C _build
ninja -C _build install
git reset --hard
git clean -xdfq
cd $this_dir
