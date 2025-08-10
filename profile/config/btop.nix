{ pkgs, ... }:

{
        programs.btop.settings = {
                color_theme = "nord";
                theme_background = false;
                proc_sorting = "memory";
        };
}
