#!/bin/bash

# A script to link the NixOS configuration from this repository to /etc/nixos.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions for Colored Output ---
info() {
    echo -e "\033[34m[INFO]\033[0m $1"
}

warn() {
    echo -e "\033[33m[WARN]\033[0m $1"
}

error() {
    echo -e "\033[31m[ERROR]\033[0m $1" >&2
    exit 1
}

success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

# --- Main Script ---

# 1. Check for root privileges
if [[ "$EUID" -ne 0 ]]; then
  error "This script must be run with sudo or as root."
fi

# 2. Get the absolute path of the directory containing the script.
# This allows the script to be run from any location.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TARGET_CONFIG_DIR="$SCRIPT_DIR/nixos"

# 3. Verify that the 'nixos' directory exists where expected.
if [[ ! -d "$TARGET_CONFIG_DIR" ]]; then
    error "The 'nixos' configuration directory was not found at '$TARGET_CONFIG_DIR'."
fi

# 4. Explain what will happen and ask for confirmation.
info "This script will link the NixOS configuration in this repository to /etc/nixos."
info "Target configuration directory: $TARGET_CONFIG_DIR"
echo
read -p "Are you sure you want to proceed? (y/N) " -n 1 -r
echo # Move to a new line

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Installation cancelled by user."
    exit 0
fi

# 5. Back up any existing /etc/nixos directory or file.
if [[ -e "/etc/nixos" ]]; then
    BACKUP_PATH="/etc/nixos.backup.$(date +%Y-%m-%d_%H-%M-%S)"
    warn "An existing entry at /etc/nixos was found."
    info "Moving it to '$BACKUP_PATH'..."
    mv /etc/nixos "$BACKUP_PATH"
fi

# 6. Create the symbolic link.
info "Creating symbolic link from /etc/nixos to '$TARGET_CONFIG_DIR'..."
ln -s "$TARGET_CONFIG_DIR" /etc/nixos

success "NixOS configuration linked successfully!"
echo
info "Don't forget the next steps:"
info "1. Ensure your machine's hardware-configuration.nix is in place."
info "2. From the 'nixos' directory, run 'sudo nixos-rebuild switch --flake .#nixos' to build your system."
