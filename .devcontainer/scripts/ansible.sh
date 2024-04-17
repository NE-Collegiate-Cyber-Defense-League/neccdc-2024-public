#!/bin/bash
set -e

install_ansible() {
    # Ensure apt is in non-interactive to avoid prompts
    export DEBIAN_FRONTEND=noninteractive

    # Install Ansible
    /usr/bin/pipx install --include-deps ansible
    # Define the packages to inject
    packages=("ansible-lint" "boto3" "argcomplete" "pywinrm" "pywinrm[kerberos]")
    
    # Loop through the packages and run the pipx inject command
    for package in "${packages[@]}"; do
        /usr/bin/pipx inject --include-apps --include-deps ansible $package
    done


    # Install galaxy collections
    /root/.local/bin/ansible-galaxy install -r /tmp/requirements.yml
}

install_ansible

