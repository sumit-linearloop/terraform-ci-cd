#!/bin/bash

# Configuration variables
GIT_REPO="git@github.com:sumit-linearloop/digitalocean-api.git"
BRANCH_NAME="DEV"
WORK_DIR="/var/www/DEV"

# Create work directory if it doesn't exist
if [ ! -d "$WORK_DIR" ]; then
    echo "Creating work directory: $WORK_DIR"
    sudo mkdir -p "$WORK_DIR"  # Use sudo to create directory
    sudo chown -R $(whoami):$(whoami) "$WORK_DIR"  # Change ownership to the current user
else
    echo "Work directory already exists: $WORK_DIR"
fi

# Navigate to work directory
cd "$WORK_DIR" || { echo "Failed to navigate to work directory: $WORK_DIR"; exit 1; }

# Check if directory is empty
if [ "$(ls -A "$WORK_DIR")" ]; then
    echo "Directory is not empty. Pulling latest changes..."
    # Pull latest changes
    git pull origin "$BRANCH_NAME" || { echo "Failed to pull latest changes."; exit 1; }
else
    echo "Directory is empty. Cloning repository..."
    # Clone repository
    git clone "$GIT_REPO" . || { echo "Failed to clone repository."; exit 1; }
    # Checkout specific branch
    git checkout "$BRANCH_NAME" || { echo "Failed to checkout branch: $BRANCH_NAME"; exit 1; }
fi

# Install dependencies and build
echo "Installing dependencies and building..."
yarn install || { echo "Failed to install dependencies."; exit 1; }
yarn build || { echo "Build failed."; exit 1; }

# Check if PM2 process exists
if pm2 list | grep -q "DEV"; then
    echo "Restarting PM2 process..."
    pm2 restart "DEV" || { echo "Failed to restart PM2 process."; exit 1; }
else
    echo "Starting new PM2 process..."
    pm2 start dist/main.js --name "DEV" || { echo "Failed to start PM2 process."; exit 1; }
fi

# Save PM2 configuration
pm2 save || { echo "Failed to save PM2 configuration."; exit 1; }

echo "Deployment completed successfully!"
