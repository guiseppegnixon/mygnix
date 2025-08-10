{ config, pkgs, inputs, flakeSettings, ... }:

{
  imports = [
      ./config/nvim.nix
#      ./config/plasma.nix
      ./config/program-settings.nix
      ./config/stevenblack-hosts.nix
      ./system/docker.nix
      ./system/hardware-configuration.nix
      ./system/network.nix
      ./system/pkgs.nix
      ./system/system.nix
      ./system/users.nix
    ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
