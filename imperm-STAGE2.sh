#!/usr/bin/env bash

git clone https://github.com/guiseppegnixon/mygnix.git ~/.nixfiles
cd ~/.nixfiles
rm -rfv ~/.nixfiles/.git

cp -v /persist/etc/nixos/hardware-configuration.nix profile/system/hardware-configuration.nix

mv -v flake-STAGE2.nix flake.nix
nvim flake.nix

mv -v configuration-STAGE2.nix profile/configuration.nix
mv -v profile/system/persist-STAGE2.nix profile/system/persist.nix
mv -v profile/system/system-IMPERM.nix profile/system/system.nix
mv -v profile/system/users-IMPERM.nix profile/system/users.nix
mv -v profile/system/hardening/hardening-IMPERM.nix profile/system/hardening/hardening.nix

echo "\n SET USER PASSWORD AND REBUILD :)"
