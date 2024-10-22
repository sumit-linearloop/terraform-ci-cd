#!/bin/bash

# Configuration variables
GIT_REPO="git@github.com:sumit-linearloop/digitalocean-api.git"
BRANCH_NAME="DEV"
WORK_DIR="/var/www/DEV"

# Function to check SSH connection
check_ssh_connection() {
    echo "Testing SSH connection to GitHub..."
    if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "Error: SSH authentication failed!"
        echo "Please ensure:"
        echo "1. SSH key is generated (ssh-keygen -t rsa -b 4096)"
        echo "2. Public key is added to GitHub (cat ~/.ssh/id_rsa.pub)"
        echo "3. SSH agent is running (eval \$(ssh-agent -s))"
        echo "4. SSH key is added to agent (ssh-add ~/.ssh/id_rsa)"
        exit 1
    fi
}

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}
