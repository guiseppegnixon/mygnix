# TO ACCESS AUDIT REPORTS:
# sudo aureport --summary
# sudo aureport -u --failed --summary
# sudo ausearch -k priv_escalation

{ config, lib, pkg, flakeSettings, ... }:

{
  services.journald = {
    storage = "persistent";
    extraConfig = ''
      SystemMaxUse=1G
    '';
  };

  security.audit.enable = true;
  security.auditd.enable = true;

  security.audit.rules = [
    # --- Rule Immutability ---
    # Start with a clean slate and make the rules immutable until the next reboot.
    # This prevents an attacker with root access from disabling the audit system.
    "-e 1" # Delete all previous rules.

    # --- Identity and Access Management ---
    # Monitor login/logout events and session initialization
    "-w /var/log/faillog -p wa -k logins"
    "-w /var/log/lastlog -p wa -k logins"
    "-w /var/run/utmp -k session"

    # --- Monitor Access Denials ---
    # Log any system call that fails due to permission errors (EPERM/EACCES).
    # This is a high-value indicator of intrusion attempts or misconfigurations.
    "-a always,exit -F arch=b64 -S all -F exit=-EPERM -k perm_denied"
    "-a always,exit -F arch=b64 -S all -F exit=-EACCES -k perm_denied"

    # --- Track Privilege Escalation ---
    # Log every execution of commands that can elevate user privileges.
    "-w /usr/bin/sudo -p x -k priv_escalation"
    "-w /usr/bin/su -p x -k priv_escalation"
    "-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k setuid"
    "-a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -k setgid"

    # --- Monitor Sensitive System Files ---
    # Watch for any writes (w) or attribute changes (a) to critical files
    # that define system or user identity and configuration.
    "-w /etc/passwd -p wa -k identity_change"
    "-w /etc/shadow -p wa -k identity_change"
    "-w /etc/group -p wa -k identity_change"
    "-w /etc/sudoers -p wa -k sudoers_change"
    "-w /etc/nixos/ -p wa -k nixos_config_change"
    "-w /home/${flakeSettings.username}/.nixfiles/ -p wa -k nixos_config_change"

    # --- Monitor Kernel Module Manipulation ---
    # Loading or unloading kernel modules is a common technique for rootkits.
    "-w /sbin/insmod -p x -k kernel_module"
    "-w /sbin/rmmod -p x -k kernel_module"
    "-w /sbin/modprobe -p x -k kernel_module"

    # --- Monitor System Identity Changes ---
    # Track changes to the system's network name or time.
    "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k sys_identity"
    "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time_change"

    # --- Finalize Rules ---
    # Lock the configuration. No more rules can be added or changed until reboot.
    "-e 2"
  ];
}
