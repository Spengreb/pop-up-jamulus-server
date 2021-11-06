#!/usr/bin/env bash
set -x

readonly AWS_ACCESS_KEY=${1}
readonly AWS_ACCESS_SECRET_KEY=${2}

PACKER_INSTALLATION_DIR=`./install-packer.sh`

${PACKER_INSTALLATION_DIR}/packer build \
    -var "aws_access_key=${AWS_ACCESS_KEY}" \
    -var "aws_secret_key=${AWS_ACCESS_SECRET_KEY}" \
    aws_ubuntu20_jamulus.json