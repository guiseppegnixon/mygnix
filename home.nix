{ inputs, config, pkgs, ... }:

{
  home.username = "guiseppe";
  home.homeDirectory = "/home/guiseppe";

  home.packages = [
    pkgs.ghostty
    pkgs.flameshot
  ];

  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      font-family = "Liberation Mono";
      background-opacity = 0.5;
      background-blur = true;
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      startupLaunch = true;
    };
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
