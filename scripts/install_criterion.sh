#!/bin/bash

# This script will install criterion

# Full script path
script_path=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`

# This directory path
dir=`dirname "${script_path}"`

dir_external="${dir}/../external"
dir_install="${dir_external}/criterion"

# Nothing to be done
if [ -d "$dir_install" ]; then
    exit 0
fi

mkdir -p $dir_external
mkdir -p $dir_install

this_dir=`pwd`
cd $dir/../submodules/Criterion
git submodule update --init
mkdir -p build
cd build
cmake ..
cmake --build .
cp libcriterion.so* $dir_install/
cp -R ../include/ $dir_install/
git reset --hard
git clean -xdfq
cd $this_dir
