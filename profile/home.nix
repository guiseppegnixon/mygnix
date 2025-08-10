{ inputs, config, pkgs, flakeSettings, ... }:

{
  imports = [
        ./config/alacritty.nix
        ./config/git.nix
                #        ./config/plasma.nix
  ];

  home.username = flakeSettings.username;
  home.homeDirectory = ( "/home" + ("/" + flakeSettings.username));

  home.packages = [
    pkgs.ghostty
  ];

  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
#      font-family = "Liberation Mono";
      background-opacity = 0.5;
      background-blur = true;
    };
  };


  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
