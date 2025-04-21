#!/bin/bash

# Check if GH_TOKEN is set
if [ -z "${GH_TOKEN}" ]; then
    echo "Error: GH_TOKEN environment variable is not set. GitHub authentication is required."
    exit 1
fi

# Authenticate with GitHub using GH_TOKEN
echo "${GH_TOKEN}" | gh auth login --with-token
if [ $? -ne 0 ]; then
    echo "Error: Failed to authenticate with GitHub. Please check your token."
    exit 1
fi
echo "Successfully authenticated with GitHub"

# Check if REPO_URL environment variable is set
if [ -z "${REPO_URL}" ]; then
    echo "Warning: REPO_URL environment variable is not set. Skipping repository clone."
else
    echo "Cloning repository from ${REPO_URL}"
    # Clone the repository
    git clone ${REPO_URL}
    echo "Repository cloned successfully"
fi

# Start JupyterLab
exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root