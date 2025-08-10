{ config, pkgs, inputs, flakeSettings, ... }:

{

        programs.alacritty = {
                enable = true;
                settings = {
                        window = {
                                opacity = 0.5;
                                blur = true;
                                title = flakeSettings.hostname;
                        };    
                        theme = "nord";
                };
        };

}
