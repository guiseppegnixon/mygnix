{ inputs, config, pkgs, lib, ... }:

{
  #automatically deploy updates
  system.autoUpgrade = {
    enable = true;
    randomizedDelaySec = "600"; #adds 0-10 minutes to trigger time to stagger updates
    operation = "boot"; #deploys update as new boot entry. use the default setting of "switch" for immediate effect.
    flake = inputs.self.outPath;
    flags = [
        "-L"
    ];
  };

  #clean up old deployments
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
}
