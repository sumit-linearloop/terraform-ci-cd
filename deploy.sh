#!/bin/bash

# Configuration variables
GIT_REPO="git@github.com:sumit-linearloop/digitalocean-api.git"
BRANCH_NAME="DEV"
WORK_DIR="/var/www/DEV"

# Create work directory if it doesn't exist
mkdir -p "$WORK_DIR"

# Navigate to work directory
cd "$WORK_DIR" || exit

# Check if directory is empty
if [ "$(ls -A $WORK_DIR)" ]; then
    echo "Directory is not empty. Pulling latest changes..."
    # Pull latest changes
    git pull origin "$BRANCH_NAME"
else
    echo "Directory is empty. Cloning repository..."
    # Clone repository
    git clone "$GIT_REPO" .
    # Checkout specific branch
    git checkout "$BRANCH_NAME"
fi

# Install dependencies and build
echo "Installing dependencies and building..."
yarn install
yarn build

# Check if PM2 process exists
if pm2 list | grep -q "DEV"; then
    echo "Restarting PM2 process..."
    pm2 restart "DEV"
else
    echo "Starting new PM2 process..."
    pm2 start dist/main.js --name "DEV"
fi

# Save PM2 configuration
pm2 save

echo "Deployment completed successfully!"
