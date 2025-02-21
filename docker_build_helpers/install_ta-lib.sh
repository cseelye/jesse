#!/bin/bash
set -euo pipefail

if [[ -z "${1-}" ]]; then
    INSTALL_LOC=/usr
else
    INSTALL_LOC="${1}"
fi

echo "Installing to ${INSTALL_LOC}"
mkdir -p "${INSTALL_LOC}"
if [[ ! -f "${INSTALL_LOC}/lib/libta_lib.a" ]]; then
    tar zxvf ta-lib-0.4.0-src.tar.gz
    cd ta-lib
    sed -i.bak "s|0.00000001|0.000000000000000001 |g" src/ta_func/ta_utility.h
    ./configure --prefix="${INSTALL_LOC}/"
    make
    which sudo && sudo make install || make install
    make clean
    echo "export LD_LIBRARY_PATH=${INSTALL_LOC}/lib" >> /root/.bashrc
else
    echo "TA-lib already installed, skipping installation"
fi
