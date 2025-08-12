# gpg-agent.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.pgp = {
      enable = lib.mkEnableOption {
        description = "Enable PGP Gnupgp";
        default = false;
      };
    };
  };

  config = lib.mkIf config.custom.pgp.enable {
    services = {
      ## Enable gpg-agent with ssh support
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableZshIntegration = true;
        pinentryPackage = pkgs.pinentry-qt;
        #pinentryPackage = pkgs.pinentry-all;
      };

      ## We will put our keygrip here
      gpg-agent.sshKeys = [];
    };
    home.packages = [pkgs.gnupg];
    programs = {
      gpg = {
        ## Enable GnuPG
        enable = true;

        # homedir = "/home/userName/.config/gnupg";
      };
    };
  };
}

