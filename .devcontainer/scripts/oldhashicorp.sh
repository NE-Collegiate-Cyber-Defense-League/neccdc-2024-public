#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/terraform.md
# Maintainer: The VS Code and Codespaces Teams

set -e

# Clean up
rm -rf /var/lib/apt/lists/*
TERRAFORM_VERSION="1.6.6"
PACKER_VERSION="1.10.0"

architecture="$(uname -m)"
case ${architecture} in
    x86_64) architecture="amd64";;
    aarch64 | armv8*) architecture="arm64";;
    aarch32 | armv7* | armvhf*) architecture="arm";;
    i?86) architecture="386";;
    *) echo "(!) Architecture ${architecture} unsupported"; exit 1 ;;
esac

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Verify requested version is available, convert latest
mkdir -p /tmp/tf-downloads
cd /tmp/tf-downloads

echo "Downloading terraform..."
terraform_filename="terraform_${TERRAFORM_VERSION}_linux_${architecture}.zip"
curl -o ${terraform_filename} "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${terraform_filename}"
unzip ${terraform_filename}
mv -f terraform /usr/local/bin/

echo "Downloading packer..."
packer_filename="packer_${PACKER_VERSION}_linux_${architecture}.zip"
curl -o ${packer_filename} "https://releases.hashicorp.com/packer/${PACKER_VERSION}/${packer_filename}"
unzip ${packer_filename}
mv -f packer /usr/local/bin/

rm -rf /tmp/tf-downloads ${GNUPGHOME}

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"