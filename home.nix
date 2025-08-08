{ inputs, config, pkgs, ... }:

{
  home.username = "guiseppe";
  home.homeDirectory = "/home/guiseppe";

  home.packages = [
    pkgs.ghostty
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

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
