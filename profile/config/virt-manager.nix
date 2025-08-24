{ config, pkgs, inputs, flakeSettings, ... }:

{

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["${flakeSettings.username}"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

}
