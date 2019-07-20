#!/bin/bash

# This script will setup env. Execute the script once to install all needed tools to develop this project.

function is_debian_based()
{
    local debian_distro=("debian" "ubuntu" "mint" "kali")
    local distro=`echo "$1" | tr '[:upper:]' '[:lower:]'`
    local is_debian=0

    local len=${#debian_distro[@]}
    for ((i = 0; i < ${len}; ++i)); do
        if [ "${distro}" == "${debian_distro[i]}" ]; then
            is_debian=1
        fi
    done

    echo $is_debian
}

# Get Linux Dist
if [ -f /etc/os-release ]; then
    . /etc/os-release
    distr=$ID_LIKE
    if [ -z "$distro" ]; then
        distro=$NAME
    fi
fi

# Full script path
script_path=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`

# This directory path
dir=`dirname "${script_path}"`

# import logger
source $dir/script_logger.sh

TOOLS=("gcc" "make" "gawk" "bc" "sed" "automake" "autoconf")

is_debian=`is_debian_based $distro`

# Debian based distro
if [ $is_debian -eq 1 ]; then
    len=${#TOOLS[@]}
    for ((i = 0; i < ${len}; ++i)); do
        if ! dpkg -l | grep -qw "${TOOLS[i]}"; then
            info "Installing ${TOOLS[i]} ..."
            sudo apt --yes install "${TOOLS[i]}" >/dev/null 2>&1 || error "${TOOLS[i]}"
            success "${TOOLS[i]} Installed"
        fi
    done
else
    echo "Linux distribution: $distro is not supoorted"
fi