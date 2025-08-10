{ config, pkgs, inputs, ... }:

{
        fonts.packages = with pkgs; [
                nerd-fonts.fira-code
                noto-fonts-emoji
                fira-code
                fira-code-symbols
                noto-fonts
        ];
}
