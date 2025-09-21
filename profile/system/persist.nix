{ config, pkgs, lib, flakeSettings, ... }:

{
  environment.persistence."/persist" = lib.mkDefault {
    directories = [
      "/etc/nixos"
      { directory = "/etc/machineid"; mode = "0444"; }
      "/etc/cups"
      "/etc/NetworkManager"
      "/etc/nixos"
      "/etc/ssh"
      "/var/cache"
      "/var/lib"
    ];
  }
}
