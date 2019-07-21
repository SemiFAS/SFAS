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

TOOLS=("gcc" "g++" "make" "cmake" "gawk" "bc" "sed" "wget" "curl" "python3" "automake" "autoconf" "pkg-config" "flex" "bison" "ninja-build" "libmount-dev")

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

# Install pip if needed
pip3 --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    info "Installing pip3 ..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py >/dev/null 2>&1 || error "Curl pip"
    sudo python3 get-pip.py >/dev/null 2>&1 || error "pip3"
    rm -f get-pip.py
    success "pip3 Installed"
fi

# Install meson if needed
meson --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
    info "Installing meson ..."
    sudo pip3 install meson >/dev/null 2>&1 || error "Meson"
    success "meson Installed"
fi

# Init submodules
git submodule init
git submodule update

# Install valgrind from submodule
if [ ! -d ${dir}/../external/valgrind ]; then
    info "Installing Valgrind ..."
    (${dir}/install_valgrind.sh >/dev/null 2>&1 && success "Valgrind Installed") || error "Valgrind"
fi

# Install Criterion from submodule
if [ ! -d ${dir}/../external/criterion ]; then
    info "Installing Criterion ..."
    (${dir}/install_criterion.sh >/dev/null 2>&1 && success "Criterion Installed") || error "Criterion"
fi

# Install GNU lib from submodule
if [ ! -d ${dir}/../external/gnulib ]; then
    info "Installing GNU Lib ..."
    (${dir}/install_gnulib.sh >/dev/null 2>&1 &&  success "GNU Lib Installed") || error "GNU Lib"
fi