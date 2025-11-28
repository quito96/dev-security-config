#!/bin/bash

# Security Configuration Setup Script
# Installs .npmrc and .cursorrules safely without overwriting existing configurations.

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Security Configuration Setup...${NC}"

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo -e "Detected OS: ${YELLOW}${MACHINE}${NC}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NPMRC_SOURCE="${SCRIPT_DIR}/.npmrc"
CURSORRULES_SOURCE="${SCRIPT_DIR}/.cursorrules"

# Function to install globally
install_global() {
    echo -e "\n${YELLOW}--- Global Installation (~/.npmrc) ---${NC}"
    TARGET_NPMRC="${HOME}/.npmrc"

    if [ -f "$TARGET_NPMRC" ]; then
        echo -e "${RED}Warning: ${TARGET_NPMRC} already exists.${NC}"
        read -p "Do you want to back it up and overwrite? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$TARGET_NPMRC" "${TARGET_NPMRC}.bak_$(date +%s)"
            echo -e "Backed up existing .npmrc."
        else
            echo -e "Skipping global .npmrc installation."
            return
        fi
    fi

    ln -sf "$NPMRC_SOURCE" "$TARGET_NPMRC"
    echo -e "${GREEN}Success: Linked .npmrc to ${TARGET_NPMRC}${NC}"
    echo -e "Verifying configuration..."
    npm config list | grep "ignore-scripts"
}

# Function to install locally (copy to current dir)
install_local() {
    echo -e "\n${YELLOW}--- Local Installation (Current Directory) ---${NC}"
    TARGET_DIR="$(pwd)"
    
    # Check .npmrc
    if [ -f "${TARGET_DIR}/.npmrc" ]; then
        echo -e "${RED}Skipping .npmrc: File already exists in ${TARGET_DIR}${NC}"
    else
        cp "$NPMRC_SOURCE" "${TARGET_DIR}/.npmrc"
        echo -e "${GREEN}Copied .npmrc to ${TARGET_DIR}${NC}"
    fi

    # Check .cursorrules
    if [ -f "${TARGET_DIR}/.cursorrules" ]; then
        echo -e "${RED}Skipping .cursorrules: File already exists in ${TARGET_DIR}${NC}"
    else
        cp "$CURSORRULES_SOURCE" "${TARGET_DIR}/.cursorrules"
        echo -e "${GREEN}Copied .cursorrules to ${TARGET_DIR}${NC}"
    fi
}

echo -e "\nSelect installation mode:"
echo "1) Global (Symlink .npmrc to user home)"
echo "2) Local (Copy .npmrc and .cursorrules to current directory)"
echo "3) Exit"

read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        install_global
        ;;
    2)
        install_local
        ;;
    3)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo -e "\n${GREEN}Setup complete!${NC}"
