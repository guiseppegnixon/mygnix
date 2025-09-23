{ config, pkgs, inputs, lib, flakeSettings, ... }:

{
  imports = [
      ./config/flatpak.nix
      ./config/fonts.nix
      ./config/nvf.nix
      ./config/offsec_packages.nix
      ./config/program-settings.nix
      ./config/starship.nix
      ./config/stevenblack-hosts.nix
      ./config/virt-manager.nix 
      ./config/yazi.nix
      ./config/zoxide.nix
      ./config/zsh.nix
      ./system/auditd-minimal.nix
      ./system/autoupdate.nix
      ./system/docker.nix
      ./system/fwupd.nix
      ./system/hardening/hardening.nix
      ./system/hardware-configuration.nix
      ./system/laptop.nix
    #./system/lanza.nix
      ./system/network.nix
      ./system/persist.nix
      ./system/pkgs.nix
      ./system/schedulers.nix
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
