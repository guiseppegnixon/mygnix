{ pkgs, ... }:

{
        services.flameshot.settings = {
                General = {
                        showStartupLaunchMessage = false;
                        startupLaunch = true;
                };
        };
}
