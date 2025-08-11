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
    pandoc

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
    nordic

    spotify
    reaper
    libreoffice-qt-fresh
    psst

    bottles
    virtualbox

    caido
    nmap
    sqlmap
    feroxbuster
    smap
    nuclei
    katana
    gau
    subfinder
    asnmap
    xnlinkfinder
    cewler

    lynis

  ];

}
