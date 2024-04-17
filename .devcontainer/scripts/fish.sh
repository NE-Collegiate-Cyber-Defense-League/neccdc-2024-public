#!/bin/bash
set -e

setup_fish_shell() {
    # Ensure apt is in non-interactive to avoid prompts
    export DEBIAN_FRONTEND=noninteractive

    # Add the fish repo
    gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/fish.gpg --keyserver keyserver.ubuntu.com --recv-keys 59FDA1CE1B84B3FAD89366C027557F056DC33CA5
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/fish.gpg] https://ppa.launchpadcontent.net/fish-shell/release-3/ubuntu  jammy main" | sudo tee /etc/apt/sources.list.d/fish-shell.list > /dev/null

    # Install the list of packages
    local package_list="fish fd-find"
    echo "Packages to verify are installed: ${package_list}"
    rm -rf /var/lib/apt/lists/*
    apt-get update -y
    apt-get -y install --no-install-recommends ${package_list} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )


    # Install FZF
    git clone --depth 1 https://github.com/junegunn/fzf.git /temp/.fzf
    /temp/.fzf/install --bin
    cp /temp/.fzf/bin/fzf /usr/local/bin/fzf

    # Install Starship
    curl -sS https://starship.rs/install.sh | sh -s -- -y


    # Clean up
    apt-get -y clean
    rm -rf /var/lib/apt/lists/*
}

setup_fish_shell

