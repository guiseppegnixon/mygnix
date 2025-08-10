{ config, pkgs, inputs, flakeSettings, ...}:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${flakeSettings.username} = {
    isNormalUser = true;
    description = flakeSettings.username;
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = flakeSettings.username;

}
