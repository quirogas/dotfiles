#!/bin/bash

export ANSIBLE_CONFIG="$HOME/.bootstrap/ansible.cfg"

install_ansible() {
    echo "Installing Ansible using Homebrew..."
    brew install ansible
}

# Check for MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running on MacOS."

    # Check if Ansible is installed
    if ! which ansible > /dev/null; then
        echo "Ansible is not installed."
        install_ansible

    else
        echo "Ansible is already installed."
    fi


    # Run Ansible Playbook 	
    echo "Running Ansible Mac OS setup"
    ansible-playbook ~/.bootstrap/playbooks/setup_mac.yml
fi

