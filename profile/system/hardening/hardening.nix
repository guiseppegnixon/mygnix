{ config, inputs, ... }:

{
  import = [
                ./systemd/*.nix
        ];

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

# below are selections from nixos-hardened which don't break things i need
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix 

  nix.settings.allowed-users = [ "@users" ];
        #  users.mutableUsers = false; # only allow declartively initiated users

  security.lockKernelModules = true;
  security.protectKernelImage = true;

  #security.allowSimultaneousMultithreading = false;

  security.forcePageTableIsolation = true;

  # This is required by podman to run containers in rootless mode.
  #security.unprivilegedUsernsClone = config.virtualisation.containers.enable;

  security.virtualisation.flushL1DataCache = "always";

  #security.apparmor.enable = true;
  #security.apparmor.killUnconfinedConfinables = true;

  boot.kernelParams = [
    # Don't merge slabs
    "slab_nomerge"

    # Overwrite free'd pages
    "page_poison=1"

    # Enable page allocator randomization
    "page_alloc.shuffle=1"
  ];

  boot.blacklistedKernelModules = [

    "dccp"
    "sctp"
    "rds"
    "tipc"

    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  boot.kernel.sysctl = {
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = false;
    "kernel.sysrq" = false;
    "kernel.unprivileged_bpf_disabled" = true;
    "net.core.bpf_jit_harden" = 2;
};
  # Hide kptrs even for processes with CAP_SYSLOG
  boot.kernel.sysctl."kernel.kptr_restrict" = 2;

  # Disable ftrace debugging
  boot.kernel.sysctl."kernel.ftrace_enabled" = false;

  # Enable strict reverse path filtering (that is, do not attempt to route
  # packets that "obviously" do not belong to the iface's network; dropped
  # packets are logged as martians).
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = "1";

  # Ignore broadcast ICMP (mitigate SMURF)
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = true;

  # Ignore incoming ICMP redirects (note: default is needed to ensure that the
  # setting is applied to interfaces added after the sysctls are set)
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = false;

  # Ignore outgoing ICMP redirects (this is ipv4 only)
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = false;

  fileSystems."/proc" = {
    device = "proc";
    fsType = "proc";
    options = ["defaults" "hidepid=2"];
    # unclear if this is actually needed
    neededForBoot = true;
  };

  services.dbus.implementation = "broker";
  security.sudo.execWheelOnly = true;

  systemd.services.systemd-rfkill = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateTmp = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };

  systemd.services.systemd-journald = {
    serviceConfig = {
      UMask = 0077;
      PrivateNetwork = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
    };
  };
}
