{ config, inputs, lib, flakeSettings, ... }:

{
  imports =  [
                #    ./clamav.nix
    ./cronjobs.nix
    ./firewall.nix
    ./kernel.nix
    ./usbguard.nix
                #./systemd-services/accounts-daemon.nix
                #./systemd-services/acipd.nix
                #./systemd-services/auditd.nix
                #./systemd-services/autovt.nix
                #./systemd-services/blocky.nix
                #./systemd-services/bluetooth.nix
                #./systemd-services/colord.nix
                #./systemd-services/cups.nix
                #./systemd-services/dbus.nix
                #./systemd-services/dbus-broker.nix
                #./systemd-services/display-manager.nix
                #./systemd-services/docker.nix
    ./systemd-services/general.nix
                #./systemd-services/getty.nix
                #./systemd-services/NetworkManager-dispatcher.nix
                #./systemd-services/NetworkManager.nix
                #./systemd-services/nix-daemon.nix
                #./systemd-services/nscd.nix
                #./systemd-services/reload-systemd-vconsole-setup.nix
                #./systemd-services/rescue.nix
                #./systemd-services/rtkit.nix
                #./systemd-services/sshd.nix
                #./systemd-services/systemd-ask-password-console.nix
                #./systemd-services/systemd-ask-password-wall.nix
                #./systemd-services/systemd-journald.nix
                #./systemd-services/systemd-machined.nix
                #./systemd-services/systemd-rfkill.nix
                #./systemd-services/systemd-udevd.nix
                #./systemd-services/user.nix
                #./systemd-services/wpa_supplicant.nix
  ];

  custom.security.usbguard.enable = true;

  #custom audit rules
  #security.audit.rules = [
    #"-w /home/${flakeSettings.username}/.nixfiles -p wa -k nixos_config_change"
    #"-w /etc/nixos/ -p wa -k nixos_config_change"
  #];

  #randomize MAC
  networking.networkmanager = {
    ethernet.macAddress = "stable";
    wifi.macAddress = "random";
  };

  #sudo-rs
  security.sudo.enable = false;
  security.sudo-rs.enable = true;

  #wayland envars
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

}
