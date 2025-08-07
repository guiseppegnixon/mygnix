{ inputs, config, pkgs, ... }:

{
  home.username = "guiseppe";
  home.homeDirectory = "/home/guiseppe";

  home.packages = [
    pkgs.ghostty
    #pkgs.vim
#    pkgs.neovim
  ];

#  imports = [
#    inputs.nix4nvchad.homeManagerModule
#  ];
#  programs.nvchad.enable = true;
#  programs.nvchad.hm-activation = true;
#  programs.nvchad.backup = false;

  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      font-family = "Liberation Mono";
      background-opacity = 0.5;
      background-blur = true;
    };
  };

#  programs.nvf.enable = true;

#  programs.vim = {
#    enable = true;
#    plugins = with pkgs.vimPlugins; [ nvchad ];
#  };
#  imports = [
#    inputs.nix4nvchad.homeManagerModule
#  ];

#  programs.nvchad.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
