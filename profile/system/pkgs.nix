{ config, pkgs, inputs, flakeSettings, ... }:

{

environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    git

    alacritty

    zsh
    starship
    eza
    bat
    ripgrep
    anew
    btop
    zoxide
    fzf
    du-dust
    ouch
    fd
    nushell

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
    vorta

    privoxy
    mullvad-vpn
    qbittorrent-enhanced

    localsend
    syncthing
    flatpak

    ansible
    #vagrant

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

    bottles
    virt-manager

    lynis
    clamav
    aide
    kernel-hardening-checker

    sbctl
    fwupd
    e2fsprogs

    monero-cli
    monero-gui
    p2pool
    xmrig

    freeplane
    goofcord
    neovide

    mat2

    skim
    thumbs
    tmuxifier
  ];

}
