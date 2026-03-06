#!/bin/bash
# Setup script for qutebrowser userscripts
# Creates symlinks from this directory to the qutebrowser userscripts directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERSCRIPTS_DIR="${HOME}/.local/share/qutebrowser/userscripts"

echo "Setting up qutebrowser userscripts..."
echo "Source directory: ${SCRIPT_DIR}"
echo "Target directory: ${USERSCRIPTS_DIR}"
echo

# Create userscripts directory if it doesn't exist
mkdir -p "${USERSCRIPTS_DIR}"

# List of userscripts to symlink (add new scripts here)
SCRIPTS=(
    "heckyesmarkdown"
)

# Create symlinks
for script in "${SCRIPTS[@]}"; do
    source_path="${SCRIPT_DIR}/${script}"
    target_path="${USERSCRIPTS_DIR}/${script}"

    if [ ! -f "${source_path}" ]; then
        echo "Warning: ${script} not found, skipping..."
        continue
    fi

    # Make script executable
    chmod +x "${source_path}"

    # Create symlink (force overwrite if exists)
    ln -sf "${source_path}" "${target_path}"
    echo "✓ Linked ${script}"
done

echo
echo "Setup complete! Userscripts are ready to use in qutebrowser."
