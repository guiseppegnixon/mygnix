{ config, pkgs, lib, ... }:

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
      # "/etc/passwd"
      #"/etc/shadow"
      #"/etc/group"
    ];

    users.niximperm = {
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
