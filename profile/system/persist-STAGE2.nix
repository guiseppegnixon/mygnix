{ config, pkgs, lib, flakeSettings, ... }:

{
  environment.persistence."/persist" = {
    directories = [
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
      #"/etc/passwd"
      #"/etc/shadow"
      #"/etc/group"
    ];

    users.${flakeSettings.username} = {
      directories = [
        ".config"
        ".local"
        ".cache"

        ".gnupg"
        ".ssh"
        ".pki"

        ".var"

        ".nixfiles"
        ".nixBU"
        ".icons"

        "Applications"
        "Desktop"
        "Documents"
        "InfoSec"
        "Library"
        "Projects"
      ];

      files = [
        ".bash_history"
        ".zsh_history"
        ".gitconfig"
        ".viminfo"
      ];
    };
  };
}
