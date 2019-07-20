#!/bin/bash

# This script will install valgrind

# Full script path
script_path=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`

# This directory path
dir=`dirname "${script_path}"`

dir_external="${dir}/../external"
dir_install="${dir_external}/valgrind"

# Nothing to be done
if [ -d "$dir_install" ]; then
    exit 0
fi

mkdir -p $dir_external
mkdir -p $dir_install

proc=`grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}'`

this_dir=`pwd`
cd $dir_install
path=`pwd`
cd $dir/../submodules/valgrind
./autogen.sh
./configure --prefix=${path}
make -j${proc}
make install
cd $this_dir