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

# Fetch the main configuration files.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/configuration-STAGE1.nix -o "$CONFIG_DIR/configuration.nix"
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/configuration-STAGE2.nix -o "$CONFIG_DIR/configuration-STAGE2.nix"
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/configuration-STAGE3.nix -o "$CONFIG_DIR/configuration-STAGE3.nix"

# Fetch the flake files.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/flake-STAGE1.nix -o "$CONFIG_DIR/flake.nix"
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/flake-STAGE2.nix -o "$CONFIG_DIR/flake-STAGE2.nix"
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/flake-STAGE3.nix -o "$CONFIG_DIR/flake-STAGE3.nix"

# Download the modular configuration components.
echo "Downloading system modules..."

# Fetch the persistence module.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/profile/system/persist.nix -o "$CONFIG_DIR/persist.nix"

# Fetch the BTRFS module.
curl -L https://raw.githubusercontent.com/guiseppegnixon/mygnix/main/profile/system/btrfs.nix -o "$CONFIG_DIR/btrfs.nix"

echo ""
echo "----------------------------------------"
echo "All configuration files downloaded successfully."
echo "Please review the new files to ensure all configurations are correct. Ensure hardware-configuration.nix is updated!"
echo "PLEASE ENSURE HARDWARE-CONFIGURATION.NIX IS UPDATED PRIOR TO INITIATING A PHASE 2 AND PHASE 3 INSTALL. IF YOU DO NOT, THE SYSTEM WILL NOT BOOT."
echo "----------------------------------------"
