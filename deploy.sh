#!/bin/bash

# Configuration variables
GIT_REPO="git@github.com:sumit-linearloop/digitalocean-api.git"
BRANCH_NAME="DEV"
WORK_DIR="/var/www/DEV"
SERVER_IP="139.59.66.18"  # Replace with your actual server IP
SERVER_USER="root"         # Replace with your server username
SSH_KEY_PATH="~/.ssh/id_rsa"  # Path to your SSH key

# Function to check remote SSH connection
check_remote_connection() {
    echo "Testing connection to remote server..."
    if ! ssh -o BatchMode=yes -o ConnectTimeout=5 ${SERVER_USER}@${SERVER_IP} echo "Connection successful" 2>/dev/null; then
        echo "Error: Cannot connect to remote server!"
        echo "Please ensure:"
        echo "1. Server IP is correct"
        echo "2. SSH key is added to the server"
        echo "3. Server firewall allows SSH connections"
        exit 1
    fi
}

# Function to setup SSH key on remote server
setup_remote_ssh() {
    echo "Setting up SSH configuration on remote server..."
    
    # Create .ssh directory and set permissions
    ssh ${SERVER_USER}@${SERVER_IP} "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
    
    # Copy local SSH key to remote server
    scp ~/.ssh/id_rsa* ${SERVER_USER}@${SERVER_IP}:~/.ssh/
    
    # Set correct permissions for SSH keys
    ssh ${SERVER_USER}@${SERVER_IP} "chmod 600 ~/.ssh/id_rsa*"
    
    # Start SSH agent on remote server
    ssh ${SERVER_USER}@${SERVER_IP} "eval \$(ssh-agent -s) && ssh-add ~/.ssh/id_rsa"
    
    # Test GitHub connection from remote server
    ssh ${SERVER_USER}@${SERVER_IP} "ssh -T git@github.com || true"
}

# Function to deploy on remote server
remote_deploy() {
    ssh ${SERVER_USER}@${SERVER_IP} "bash -s" << 'ENDSSH'
    # Configuration
    WORK_DIR="/var/www/DEV"
    GIT_REPO="git@github.com:sumit-linearloop/digitalocean-api.git"
    BRANCH_NAME="DEV"

    # Start SSH agent
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_rsa

    # Create and navigate to work directory
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR" || exit 1

    # Check if directory is empty
    if [ "$(ls -A $WORK_DIR)" ]; then
        echo "Directory is not empty. Pulling latest changes..."
        git pull origin "$BRANCH_NAME" || exit 1
    else
        echo "Directory is empty. Cloning repository..."
        git clone "$GIT_REPO" . || exit 1
        git checkout "$BRANCH_NAME" || exit 1
    fi

    # Install dependencies and build
    echo "Installing dependencies and building..."
    yarn install || exit 1
    yarn build || exit 1

    # PM2 process management
    if pm2 list | grep -q "DEV"; then
        echo "Restarting PM2 process..."
        pm2 restart "DEV" || exit 1
    else
        echo "Starting new PM2 process..."
        pm2 start dist/main.js --name "DEV" || exit 1
    fi

    # Save PM2 configuration
    pm2 save || exit 1

    echo "Deployment completed successfully!"
ENDSSH
}

# Main execution
echo "Starting deployment process..."

# Check remote connection
check_remote_connection || exit 1

# Setup SSH on remote server
setup_remote_ssh || exit 1

# Execute deployment
remote_deploy

echo "Deployment process completed!"
