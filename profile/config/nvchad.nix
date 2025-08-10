{ inputs, config, pkgs, flakeSettings, ... }:

{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  pkgs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      neovim
      neovide
      marksman
      bash-language-server
      docker-compose-language-service
      docker-language-server
      dockerfile-language-server-nodejs
      gopls
      nginx-language-server
      nil
      python314Packages.python-lsp-server
      rust-analyzer
      sqls
      systemd-language-server
    ];
    hm-activation = true;
    backup = true;
    viAlias = true;
    vimAlias = true;
  };
}
