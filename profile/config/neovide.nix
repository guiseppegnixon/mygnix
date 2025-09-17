{ config, pkgs, ... }:

{
  programs.neovide.settings = {
    neovim-bin = "/run/current-system/sw/bin/nvim";
  };
}
