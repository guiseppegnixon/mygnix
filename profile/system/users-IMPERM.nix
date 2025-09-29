{ config, pkgs, inputs, flakeSettings, ...}:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${flakeSettings.username} = {
    isNormalUser = true;
    description = flakeSettings.username;
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    hashedPassword = "$6$04X1MlykoIgheeBT$yWM8rheJXXOZDUogEa915Y2nZNHDku9vOXDwCVmRXS4ju6lxj7DktH5qY7y34iQhY2O9xyNnobU3Xl3XoQG6l0";
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = flakeSettings.username;

}
