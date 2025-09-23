#!/usr/bin/env bash

# The script will exit immediately if any command fails.
set -e

# --- Configuration ---
# Define the target directory for clarity and easy modification.
CONFIG_DIR="/mnt/persist/etc/nixos"

# --- Main Execution ---
# Navigate to the target directory. This isn't strictly necessary as we use
# full paths, but it's good practice.
cd "$CONFIG_DIR"

# Backup the original, generated configuration files.
echo "Backing up generated configuration.nix ..."
mv -v configuration.nix configuration.nix.BAK
echo "Backup complete."

# Download the new, correct configuration files from the repository.
echo "Downloading stage 1 configuration files..."

# Fetch the main configuration file.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/profile/configuration-STAGE1.nix -o "$CONFIG_DIR/configuration.nix"

# Fetch the flake file.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/profile/flake-STAGE1.nix -o "$CONFIG_DIR/flake.nix"

# Download the modular configuration components.
echo "Downloading system modules..."

# Fetch the persistence module.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/profile/system/persist.nix -o "$CONFIG_DIR/persist.nix"

# Fetch the Lanzaboote module.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/profile/system/lanza.nix -o "$CONFIG_DIR/lanza.nix"

# Fetch the BTRFS module.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/profile/system/btrfs.nix -o "$CONFIG_DIR/btrfs.nix"

echo ""
echo "----------------------------------------"
echo "All configuration files downloaded successfully."
echo "Please review the new files to ensure all configurations are correct. Ensure hardware-configuration.nix is updated!"
echo "----------------------------------------"
