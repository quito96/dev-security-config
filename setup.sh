#!/usr/bin/env bash

# Security Configuration Injection Script
# Injects .npmrc, .cursorrules, and Security-Advisory into the parent project.

set -euo pipefail
IFS=$'\n\t'

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Security Configuration Injection...${NC}"

# Determine directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_DIR="$(dirname "$SCRIPT_DIR")" # Parent directory

echo -e "Source: ${YELLOW}${SCRIPT_DIR}${NC}"
echo -e "Target Project: ${YELLOW}${TARGET_DIR}${NC}"

# Optional safety check: does target look like a project?
if [ ! -d "${TARGET_DIR}/.git" ]; then
    echo -e "${YELLOW}Warning: Target directory does not contain a .git folder.${NC}"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Aborting.${NC}"
        exit 1
    fi
fi

# Files to copy
NPMRC_SOURCE="${SCRIPT_DIR}/.npmrc"
CURSORRULES_SOURCE="${SCRIPT_DIR}/.cursorrules"
ADVISORY_SOURCE="${SCRIPT_DIR}/Security-Advisory"

REPORT_FILE="${TARGET_DIR}/SECURITY_SETUP_REPORT.md"

# Ensure required sources exist
for src in "$NPMRC_SOURCE" "$CURSORRULES_SOURCE" "$ADVISORY_SOURCE"; do
    if [ ! -e "$src" ]; then
        echo -e "${RED}Error: Required source not found: ${src}${NC}"
        exit 1
    fi
done

# Tracking for report
INSTALLED_FILES=()

# Function to copy file safely
copy_file() {
    local src=$1
    local dest_name=$2
    local dest_path="${TARGET_DIR}/${dest_name}"

    if [ -f "$dest_path" ]; then
        echo -e "${RED}Warning: ${dest_name} already exists in project.${NC}"
        read -p "Overwrite? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$src" "$dest_path"
            echo -e "Overwrote ${dest_name}."
            INSTALLED_FILES+=("${dest_name} (Overwritten)")
        else
            echo -e "Skipped ${dest_name}."
            INSTALLED_FILES+=("${dest_name} (Skipped)")
        fi
    else
        cp "$src" "$dest_path"
        echo -e "${GREEN}Injected ${dest_name}.${NC}"
        INSTALLED_FILES+=("${dest_name}")
    fi
}

# 1. Inject Configuration Files
echo -e "\n${YELLOW}--- Injecting Configuration ---${NC}"
copy_file "$NPMRC_SOURCE" ".npmrc"
copy_file "$CURSORRULES_SOURCE" ".cursorrules"

# 2. Inject Security Advisory
echo -e "\n${YELLOW}--- Injecting Advisory ---${NC}"
DEST_ADVISORY="${TARGET_DIR}/Security-Advisory"
if [ -d "$DEST_ADVISORY" ]; then
    echo -e "${RED}Warning: Security-Advisory folder already exists.${NC}"
    read -p "Overwrite contents? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp -R "$ADVISORY_SOURCE"/. "$DEST_ADVISORY"/
        echo -e "Updated Security-Advisory."
        INSTALLED_FILES+=("Security-Advisory/ (Updated)")
    else
        echo -e "Skipped Security-Advisory."
        INSTALLED_FILES+=("Security-Advisory/ (Skipped)")
    fi
else
    cp -R "$ADVISORY_SOURCE" "$TARGET_DIR/"
    echo -e "${GREEN}Injected Security-Advisory folder.${NC}"
    INSTALLED_FILES+=("Security-Advisory/")
fi

# 3. Generate Report
echo -e "\n${YELLOW}--- Generating Report ---${NC}"
{
    echo "# Security Setup Report"
    echo ""
    echo "**Date:** $(date)"
    echo "**Source Repo:** [https://github.com/quito96/dev-security-config.git](https://github.com/quito96/dev-security-config.git)"
    echo ""
    echo "## Actions Taken"
    for item in "${INSTALLED_FILES[@]}"; do
        echo "- $item"
    done
    echo ""
    echo "## Next Steps"
    echo "1. Review the injected \`.npmrc\` and \`.cursorrules\`."
    echo "2. Read \`Security-Advisory/NPM-SupplyChainSecurity.md\`."
    echo "3. Commit these changes to your project."
} > "$REPORT_FILE"
echo -e "${GREEN}Report created at ${REPORT_FILE}${NC}"

# 4. Cleanup
echo -e "\n${YELLOW}--- Cleanup ---${NC}"
read -p "Do you want to delete the 'dev-security-config' installer directory? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # extra safety before rm -rf
    if [ -z "$SCRIPT_DIR" ] || [ "$SCRIPT_DIR" = "/" ]; then
        echo -e "${RED}Refusing to delete unsafe SCRIPT_DIR: '$SCRIPT_DIR'${NC}"
        exit 1
    fi
    echo -e "Deleting ${SCRIPT_DIR}..."
    rm -rf "$SCRIPT_DIR"
    echo -e "${GREEN}Cleanup complete.${NC}"
else
    echo -e "Installer directory kept."
fi

echo -e "\n${GREEN}Security injection finished!${NC}"
