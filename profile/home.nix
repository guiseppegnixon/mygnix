{ inputs, config, pkgs, flakeSettings, ... }:

{
  imports = [
        ./config/alacritty.nix
        ./config/btop.nix
        ./config/flameshot.nix
        ./config/git.nix
                #        ./config/monero.nix
                #        ./config/p2pool.nix
        ./config/plasma.nix
        ./config/gpg-agent.nix
        ./config/yt-dlp.nix
  ];

  custom.pgp.enable = true;

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

  dconf.settings = {
                "org/virt-manager/virt-manager/connections" = {
                        autoconnect = ["qemu:///system"];
                        urls = ["qwmu:///system"];
                };
        };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
