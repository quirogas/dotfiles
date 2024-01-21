#!/bin/bash

# Check if Homebrew is installed
if which brew > /dev/null; then
    echo "Homebrew is already installed."
else
    echo "Homebrew not found. Installing Homebrew..."
    # Run the official Homebrew installation script
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
