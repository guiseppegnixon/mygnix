{ config, pkgs, inputs, flakeSettings, ... }:

{

environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    git

    ghostty
    alacritty

    zsh
    starship
    eza
    bat
    ripgrep
    anew
    btop

    neovim
    xclip

    tree
    fastfetch
    flameshot

    yt-dlp

    brave
    ungoogled-chromium
    tor-browser
    mullvad-browser
    calibre
    obsidian

    keepassxc
    veracrypt
    borgbackup

    privoxy
    mullvad
    qbittorrent-enhanced

    localsend
    syncthing

    ansible
    vagrant

    rustup
    python314
    go
    typescript

    kdePackages.filelight
    kdePackages.plasma-workspace-wallpapers
    kdePackages.partitionmanager
    kdePackages.isoimagewriter

    spotify
    reaper
    libreoffice-qt-fresh
    psst

    bottles
    virtualbox

  ];

}
