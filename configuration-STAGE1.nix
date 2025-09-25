{ pkgs, ... }: {
	imports = [
	  ./hardware-configuration.nix
    ./persist.nix # This file now manages ALL persistent state
  ];

  nix.settings.download-buffer-size = 524288000;

  # --- Security Hardening ---
  networking.firewall.enable = true;

  # --- Users ---
  users.users.niximperm = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    password = "asd";
  };
  
  # --- System Settings ---
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
    
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  powerManagement.cpuFreqGovernor = "powersave";
      
  # --- Basic System Settings ---
  time.timeZone = "America/New_York";
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [ 
	  neovim 
	  git 
	  sbctl
	  wget
	  curl
	  tree
 ];

  system.stateVersion = "25.05"; 
}
