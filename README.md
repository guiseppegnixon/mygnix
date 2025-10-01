### Introduction

This repository began as a backup for my NixOS configuration and now simultaneously serves the purpose of staging files for an impermanent NixOS installation process. This process is intended to install an impermanent NixOS workstation via tmpfs as `/`, while also installing a BTRFS filesystem, full disk encryption, and secure boot via Lanzaboote (featuring TPM2 unlocking of LUKS).

This process was compiled by Gemini Pro 2.5 and refined by myself through iterative VM installs. It directly utilizes source material / was heavily inspired by the following sources:

- https://willbush.dev/blog/impermanent-nixos/ (1)
- https://laniakita.com/blog/nixos-fde-tpm-hm-guide (2)
- https://notashelf.dev/posts/impermanence (3)
- https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md (4)
- https://github.com/nix-community/impermanence (5)

The process occurs over three stages:
- Stage 1 installs a minimum CLI system with impermanence and FDE to ensure proper system initialization.
- Stage 2 installs my full system configuration (without Lanzaboote modules)
- Stage 3 installs Lanzaboote and enables TPM-based unlocking of LUKS volumes

Feel free to use these files and the associated setup instructions at your own risk. If you mess up, it will be funny.

---
### Instructions

#### Stage 1
The purpose of Stage 1 is to perform low-level setup steps such as LUKS encryption and filesystem setup before installing a basic, impermanent configuration via flakes. 

At the end of this stage the user will be able to boot into a full disk encrypted, CLI-only system with impermanence enabled.

0. Boot into minimal NixOS ISO.
1. Switch to root and connect to wifi if needed:
```sh
sudo su -
ip link a
ip link set wlp2s0 up
systemctl start wpa_supplicant.service
wpa_cli

> scan
> scan_results
> add_network
> set_network 0 ssid "SSID"
> set_network 0 psk "PASSWORD"
> set_network 0 key_mgmt WPA-PSK
> enable_network 0 

ping example.com
```

2. Download Stage 1 install script and ensure correct `DISK` value:
```sh
curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/imperm-install.sh -o imperm-install.sh
chmod +x imperm-install.sh
vim imperm-install.sh
./imperm-install.sh
```
- The script will drop users into a vim session for `hardware-configuration.nix`. This file **must** be edited to remove all `filesystem` entries **AND** to import `./btrfs.nix`. `boot.initrd.luks.devices` must also be confirmed to be correct. **Otherwise, the installation will fail**.

3. Verify script properly executes, then reboot.
 
#### Stage 2
The purpose of Stage 2 is to install a fully configured NixOS system with impermanence and full disk encryption enabled. Stage 2 is intended to be the penultimate step prior to Stage 3's installation of Lanzaboote and TPM-based LUKS unlocking.

Some important points to note:
- The way these instructions currently operate, you will have to rerun `imperm-STAGE2.sh` after completing Stage 2. The logic will have to be refactored to fix this. Sorry :)
- `flake.nix` has a custom `flakeSettings` output allowing for population of `username`, `hostname`, and `email` fields throughout this config. They are currently set to sample values. 
	- **PRIOR TO EXECUTING `sudo nixos-rebuild switch --flake`, `flake.nix` AND `imperm-STAGE2.sh` MUST BE MODIFIED TO ENSURE THEIR HOSTNAMES ARE MATCHING** -- otherwise the rebuild will fail.
- **THE INITIAL USER PASSWORD IS `asd`!** 
- user passwords are currently set via the `hashedPassword` attribute in `profile/system/users.nix`, whose value can be populated with the following command:
```sh
mkpasswd -m sha-512
```
- `users.users.${flakeSettings}.password` can be used during setup since it may be tedious or impractical to set a hash without readily availble terminal multiplexing and copy/paste.

0. Connect to internet/wifi if needed:
```sh
sudo nmcli radio wifi on
sudo nmcli dev wifi list
sudo nmcli --ask dev wifi connect "SSID"
```

1.  Download and execute `imperm-STAGE2.nix`:
```sh
curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/imperm-STAGE2.sh
chmod +x imperm-STAGE2.sh
./imperm-STAGE2.sh

sudo nixos-rebuild switch --flake .#[HOSTNAME]
```
- This is a large build, and there's a chance for a non-zero exit code following the scripts final `sudo nixos-rebuild switch` command. My informal testing has shown this will typically resolve by a `cd ~/.nixfiles; sudo nixos-rebuild switch --flake #.[HOSTNAME]`, where `HOSTNAME` reflects what was entered in `flake.nix`. 

2. Verify proper code execution and reboot. The system should boot into a KDE desktop with your configured user present.

#### Stage 3
The purpose of Stage 3 is to install Lanzaboote and enable TPM-based unlocking of LUKS. This section is based almost exclusively off of sources (2) and (5) above. 

This section will be mostly manual. Scripting a sensitive operation like this does not seem advisable at this time.

0. Confirm prerequisites:
```sh
sudo bootctl status
```
- current firmware needs to be UEFI.
- bootloader must be `systemd-boot`.
- TPM2 must be available.

1. Set a **STRONG** BIOS password
	1. I'm not going to tell you how to do this.

2. Create secure boot keys:
```sh
sudo sbctl create-keys
```
- *note that these keys are saved to `/var/lib`. this should be in your `persist.nix`!*

3. Position Stage 3 files:
```sh
cd ~/.nixfiles
mv flake-STAGE3.nix flake.nix
mv configuration-STAGE3.nix profile/configuration.nix

vim flake.nix # EDIT: username, hostname, email
```

4. Rebuild system:
```sh
sudo nixos-rebuild switch --flake .#[HOSTNAME]
```

5. Verify machine is ready for secure boot:
```sh
sudo sbctl verify
Verifying file database and EFI images in /boot...
✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
✓ /boot/EFI/Linux/nixos-generation-355.efi is signed
✓ /boot/EFI/Linux/nixos-generation-356.efi is signed
✗ /boot/EFI/nixos/0n01vj3mq06pc31i2yhxndvhv4kwl2vp-linux-6.1.3-bzImage.efi is not signed
✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
```
- *`*bzImage.efi` files are expected to not be signed.*

6. Enable secure boot in setup mode
	1. Boot to BIOS.
	2. Security > Secure Boot (typically).
	3. Reset to Setup Mode.
		1. **DO NOT CLEAR ALL SECURE BOOT KEYS!**

7. Boot into system and enroll keys:
```sh
sudo sbctl enroll-keys --microsoft
```

8. Reboot and verify secure boot is activated:
```sh
bootctl status
System:
      Firmware: UEFI 2.60 (INSYDE Corp. 225332)
 Firmware Arch: x64
   Secure Boot: enabled (user)
  TPM2 Support: yes
  Measured UKI: yes
  Boot into FW: supported
```
- TPM2 should show yes.
- Measured UKI should show yes.
- should also check file size of `/sys/firmware/efi/efivars/dbx-*` to ensure they are not empty.

9. Implement `lanza-STAGE2.nix`:
```sh
cd ~/.nixfiles
mv -v profile/system/lanza-STAGE2.nix profile/system/lanza.nix
sudo nixos-rebuild switch --flake

luksCryptenroller
```
- this will define a custom `luksCryptenroller` function to enroll a specified LUKS device into TPM2 unlocking.

10. Reboot and verify proper boot sequence (including TPM2 LUKS unlock).

---

### Recommended Post-Install Configuration Steps

1. Configure KDE.

2. Import backups.

3. Configure usbguard:
```sh 
sudo usbguard generate-policy > /var/lib/usbguard/usbguard-rules.conf
```
- this will configure an allowlist based on connected devices.
- edit `profile/system/hardening/hardening.nix` to import `usbguard.nix` (simply uncomment the relevant line).

4. Edit `profile/system/hardening/audit.nix` **line 106** to reflect current username
