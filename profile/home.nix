{ inputs, config, pkgs, flakeSettings, ... }:

{
  imports = [
        ./config/alacritty.nix
        ./config/btop.nix
        ./config/flameshot.nix
        ./config/git.nix
        ./config/gpg-agent.nix
       #./config/monero.nix
        ./config/neovide.nix
        ./config/nushell.nix
       #./config/p2pool.nix
        ./config/plasma.nix
        ./config/tmux.nix
        ./config/yt-dlp.nix
  ];

  custom.pgp.enable = true;

  programs.yazi.enableZshIntegration = true;

  home.username = flakeSettings.username;
  home.homeDirectory = ( "/home" + ("/" + flakeSettings.username));

  dconf.settings = {
                "org/virt-manager/virt-manager/connections" = {
                        autoconnect = ["qemu:///system"];
                        urls = ["qwmu:///system"];
                };
        };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
