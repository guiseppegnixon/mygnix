{ pkgs, ... }: {
	imports = [
	  ./hardware-configuration.nix
    ./persist.nix # This file now manages ALL persistent state
  ];

  # --- Security Hardening ---
  networking.firewall.enable = true;

  # --- Users ---
  users.users.changeme = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "asd";
  };
  
  # --- System Settings ---
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
    
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  powerManagement.cpuFreqGovernor = "powersave";
      
  # --- Basic System Settings ---
  time.timeZone = "America/New_York";
  networking.hostName = "CHANGEMEBITCHPLEASE";
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
