#!/bin/bash

# Check if GH_TOKEN is set and authenticate with GitHub if available
if [ -n "${GH_LOGIN_TOKEN}" ]; then
    echo "GH_LOGIN_TOKEN found, authenticating with GitHub..."
    # set GH_TOKEN environment variable
    echo "${GH_LOGIN_TOKEN}" | gh auth login --with-token
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to authenticate with GitHub. Continuing without authentication."
    else
        echo "Successfully authenticated with GitHub"
    fi
else
    echo "GH_TOKEN not set, skipping GitHub authentication"
fi

# Check if REPO_URL environment variable is set
if [ -z "${REPO_URL}" ]; then
    echo "Warning: REPO_URL environment variable is not set. Skipping repository clone."
else
    echo "Cloning repository from ${REPO_URL}"
    # Clone the repository
    git clone ${REPO_URL} .
    echo "Repository cloned successfully"
fi

# Start JupyterLab
exec jupyter lab --ip=0.0.0.0 --port=8888 --allow-origin="*" --no-browser --allow-root