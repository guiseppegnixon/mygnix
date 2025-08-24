{ config, pkgs, lib, flakeSettings, ... }:

{
  programs.nushell = {
    enable = true;
    plugins = [
      #pkgs.nushellPlugins.net
      pkgs.nushellPlugins.skim
      #pkgs.nushellPlugins.units
      pkgs.nushellPlugins.highlight
    ];
  };

  home.shell.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.yazi.enableNushellIntegration = true;
  programs.eza.enableNushellIntegration = true;
}
