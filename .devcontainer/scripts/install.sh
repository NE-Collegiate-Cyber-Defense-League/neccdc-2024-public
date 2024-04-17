#!/bin/bash
#-------------------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://github.com/devcontainers/features/blob/main/LICENSE for license information.
#-------------------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/devcontainers/features/tree/main/src/common-utils
# Maintainer: The Dev Container spec maintainers

set -e

INSTALL_ZSH="${INSTALLZSH:-"true"}"
CONFIGURE_ZSH_AS_DEFAULT_SHELL="${CONFIGUREZSHASDEFAULTSHELL:-"false"}"
UPGRADE_PACKAGES="${UPGRADEPACKAGES:-"true"}"

change_ssh_ownership() {
    # Ensure the SSH directory is owned by the user
    chown -R root:root /root/.ssh
    chmod 600 /root/.ssh/id_rsa
    chmod 644 /root/.ssh/id_rsa.pub
}

install_debian_packages() {
    export DEBIAN_FRONTEND=noninteractive
    local package_list=""
    if [ "${PACKAGES_ALREADY_INSTALLED}" != "true" ]; then
        package_list="apt-transport-https \
        apt-utils \
        bat \
        bzip2 \
        ca-certificates \
        curl \
        dialog \
        dirmngr \
        exa \
        findutils \
        git \
        gnupg2 \
        gpg \
        htop \
        init-system-helpers \
        iproute2 \
        jq \
        less \
        libc6 \
        libgcc1 \
        libkrb5-dev \
        libgssapi-krb5-2 \
        libicu[0-9][0-9] \
        libkrb5-3 \
        liblttng-ust[0-9] \
        libstdc++6 \
        locales \
        lsb-release \
        lsof \
        man-db \
        manpages \
        manpages-dev \
        nano \
        ncdu \
        net-tools \
        openssh-client \
        pipx \
        procps \
        psmisc \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        ripgrep \
        rsync \
        software-properties-common \
        strace \
        sudo \
        sshpass \
        tree \
        unzip \
        vim-tiny \
        wget \
        wireguard \
        zip \
        zlib1g"
    fi

    # Install the list of packages
    echo "Packages to verify are installed: ${package_list}"
    rm -rf /var/lib/apt/lists/*
    apt-get update -y
    apt-get -y install --no-install-recommends ${package_list} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

    # Install zsh (and recommended packages) if needed
    if [ "${INSTALL_ZSH}" = "true" ] && ! type zsh > /dev/null 2>&1; then
        apt-get install -y zsh
    fi

    # Get to latest versions of all packages
    if [ "${UPGRADE_PACKAGES}" = "true" ]; then
        apt-get -y upgrade --no-install-recommends
        apt-get autoremove -y
    fi

    # Ensure at least the en_US.UTF-8 UTF-8 locale is available = common need for both applications and things like the agnoster ZSH theme.
    if [ "${LOCALE_ALREADY_SET}" != "true" ] && ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
        echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
        locale-gen
        LOCALE_ALREADY_SET="true"
    fi

    PACKAGES_ALREADY_INSTALLED="true"

    # Clean up
    apt-get -y clean
    rm -rf /var/lib/apt/lists/*
}

install_debian_packages
change_ssh_ownership
