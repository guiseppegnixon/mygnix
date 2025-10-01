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
    hashedPassword = "$6$iBJz.2SoOrq9gB0I$dtWb4qAZP9MsGPwWaxW50EX5N7iD6lu5bJd6AYMfjjP0YR10M/MBOH1DUKF9TMe0SEpemGttXF4q5fXqc1sx30";
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = flakeSettings.username;

}
