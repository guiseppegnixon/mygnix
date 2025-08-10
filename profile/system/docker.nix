{ pkgs, lib, flakeSettings, ... }:

#assert lib.asserts.assertOneOf "storageDriver" storageDriver [
#  null
#  "aufs"
#  "btrfs"
#  "devicemapper"
#  "overlay"
#  "overlay2"
#  "zfs"
#];

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
#    storageDriver = storageDriver;
    autoPrune.enable = true;
    daemon.settings = {
      dns = [ "9.9.9.9" ];
    };
  };

  users.users.${flakeSettings.username}.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    lazydocker
  ];
}
