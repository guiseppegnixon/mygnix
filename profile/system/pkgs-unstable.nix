{ config, pkgs, pkgs-unstable, inputs, flakeSettings }:

{

environment.systemPackages = with flakeSettings.pkgs-unstable; [
    caido
  ];  
}
