{ config, pkgs, inputs, flakeSettings, zsh, ... }:

{

        programs.alacritty = {
                enable = true;
                shell.program = ${zsh}/bin/zsh;
                settings = {
                        window = {
                                opacity = 0.5;
                                blur = true;
                                title = flakeSettings.hostname;
                        };    
                };
        };

}
