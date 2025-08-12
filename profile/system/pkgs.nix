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
    mullvad-vpn
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
#    virtualbox
    virt-manager

    caido

    nmap
    smap

    subfinder
    asnmap
    gungnir

    nuclei
    katana
    feroxbuster
    sqlmap
    gau
    xnlinkfinder

    cewler

    lynis
    clamav
    chkrootkit
    aide
    kernel-hardening-checker

    sbctl

    monero-cli
    monero-gui
    p2pool
    xmrig
  ];

}
