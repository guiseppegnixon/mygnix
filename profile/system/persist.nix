{ config, pkgs, lib, flakeSettings, ... }:

{
  environment.persistence."/persist" = {
    directories = [
      "/etc/cups"
      "/etc/mullvad-vpn"
      "/etc/NetworkManager"
      "/etc/nixos"
      "/etc/ssh"
      "/var/cache"
      "/var/db"
      "/var/lib"
      "/var/log"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.${flakeSettings.username} = {
      directories = [
        # 1. XDG Standard Directories (covers 80% of modern applications)
        ".config"      # Application configurations.
        ".local"       # User-specific data and state (includes .local/share).
        ".cache"       # Non-essential data that improves performance.

        # 2. Security & Identity
        ".gnupg"       # GPG keys for encryption and signing.
        ".ssh"         # SSH keys and known_hosts.
        ".pki"         # Public Key Infrastructure certificates.

        # 3. Critical Applications with Non-XDG Configurations
        ".var"         # Standard location for Flatpak application data and overrides.

        # 4. Personal Nix Workflow & Customizations
        ".nixfiles"    # Your personal NixOS configuration files.
        ".nixBU"       # Your backups of said files.
        ".icons"

        # 5. Personal Data Folders (The actual "work" on the computer)
        "Applications"
        "Desktop"
        "Documents"
        "InfoSec"
        "Library"
        "Projects"
        # "Downloads" is intentionally omitted to enforce a clean workflow.
        # Downloaded files must be moved to a persistent directory to be kept.
      ];

      files = [
        # 6. Shell History & Productivity Tools
        ".bash_history"
        ".zsh_history"
        ".gitconfig"
        ".viminfo"
        ".gtkrc-2.0"   # Legacy GTK2 theme settings for older applications.
      ];
    };
  };
}
