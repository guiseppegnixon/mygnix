#!/usr/bin/env bash

mv -v flake-STAGE3.nix flake.nix
nvim flake.nix

mv -v configuration-STAGE3.nix profile/configuration.nix
