# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./stevenblack-hosts.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-42160eb2-606c-4728-8a73-e8e539ac5d50".device = "/dev/disk/by-uuid/42160eb2-606c-4728-8a73-e8e539ac5d50";
  networking.hostName = "nixheim"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    extraCommands = 
    '' 
       iptables -A DOCKER-USER -m physdev 
       iptables -A DOCKER-USER -i br-+ -o br-+ -j DROP 
    '';
  };

  nix.settings = { download-buffer-size = 524288000; };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [ "9.9.9.9" ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
#  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.guiseppe = {
    isNormalUser = true;
    description = "guiseppe";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "guiseppe";

  # Install firefox.
#  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    
#    neovim
    ghostty    

    zsh
    starship
    eza
    bat
    ripgrep
    anew
    btop
    neofetch

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

    kdePackages.filelight
    kdePackages.partitionmanager
    kdePackages.isoimagewriter
 
    spotify
    reaper
    libreoffice-qt-fresh
    psst

    lunarvim

  ];

  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons=always --group-directories-first";
      cat = "bat";
      grep = "rg";
      nv = "nvim";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "(0x9A348E)$username(fg:0x9A348E bg:0xDA627D)$directory$line_break$character";
      character = {
        format = "$symbol ";
        vicmd_symbol = "[](bold green)";
        disabled = false;
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };

      directory = {
        disabled = false;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        home_symbol = "~";
        read_only = " ";
        read_only_style = "red";
        repo_root_format = "[$before_root_path]($style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        style = "cyan bold bg:0xDA627D";
        truncate_to_repo = true;
        truncation_length = 3;
        truncation_symbol = "…/";
        use_logical_path = true;
        use_os_path_sep = true;
      };

      username = {
        format = "[$user]($style) ";
        show_always = true;
        style_root = "red bold bg:0x9A348E";
        style_user = "yellow bold bg:0x9A348E";
        disabled = false;
      };
    };
  };

#  programs.nvf = {
#    enable = true;
#    vim.viAlias = true;
#    vim.vimAlias = true;
#    vim.lsp.enable = true;
#
#  };
  
#  programs.nvchad.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
