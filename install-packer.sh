#!/usr/bin/env bash

PACKER_INSTALLATION_DIR="."

# Install Packer
if ! command -v packer > /dev/null 2>&1; then
    curl https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip -o packer.zip >/dev/null
    unzip -o packer.zip -d ${PACKER_INSTALLATION_DIR} >/dev/null
    rm ${PACKER_INSTALLATION_DIR}/packer.zip
else
    PACKER_INSTALLATION_DIR="$(dirname `command -v packer`)"
fi

echo ${PACKER_INSTALLATION_DIR}