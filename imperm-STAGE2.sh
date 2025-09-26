#!/usr/bin/env bash

git clone https://github.com/guiseppegnixon/mygnix.git ~/.nixfiles
cd ~/.nixfiles
rm -rfv ~/.nixfiles/.git

cp -v /persist/etc/nixos/hardware-configuration.nix profile/system/hardware-configuration.nix

mv flake-STAGE2.nix flake.nix
mv configuration-STAGE2.nix profile/configuration.nix
mv profile/system/persist-STAGE2.nix profile/system/persist.nix

nvim flake.nix
nvim profile/system/system.nix
nvim profile/system/hardening/hardening.nix

sudo nixos-rebuild switch --flake .#nixos #CHANGEME
