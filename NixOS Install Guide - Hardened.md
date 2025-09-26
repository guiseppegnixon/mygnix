### **A Definitive Guide to a Secure, Impermanent NixOS Laptop (Final Version)**

This guide creates a system where the operating system and user environment are ephemeral by default, maximizing security and reproducibility. All persistent data is explicitly managed.

#### **System Attributes**

*   **Full Disk Encryption (FDE):** All data resides within a LUKS2 encrypted container.
*   **TPM-Sealed Decryption:** The LUKS key is sealed in the TPM for passwordless, secure boot.
*   **Secure Boot:** A custom chain of trust ensures only your cryptographically signed kernel and bootloader can run.
*   **Impermanent `tmpfs` Root:** The entire root filesystem (`/`), including `/home`, is a clean slate in RAM on every boot.
*   **BTRFS Persistence:** All persistent data (`/nix`, `/etc/nixos`, logs, and selected user files) is managed on flexible BTRFS subvolumes.

---

### **Phase 1: Preparation and UEFI Configuration**

1.  **Backup All Data:** The target disk will be completely erased.
2.  **Create NixOS Installer:** Flash the latest stable NixOS minimal ISO to a USB drive.
3.  **Configure UEFI/BIOS:** Reboot and enter the setup utility.
    *   **Set a strong UEFI Administrator Password.** This is critical to prevent physical attackers from disabling security settings.
    *   Ensure the system is in **UEFI Native Mode** (not Legacy/CSM).
    *   **Disable Secure Boot** temporarily.
    *   Verify the system clock is correct.
4.  **Boot and Prepare:**
    *   Boot from the NixOS USB drive.
    *   Identify your target disk with `lsblk`. This guide will use `<your-disk>` (e.g., `/dev/nvme0n1`).
5.  **Connect to Wifi:** (if needed):
```sh 
sudo ip link
sudo ip link set [wireless interface] up
sudo systemctl start wpa_supplicant
sudo wpa_cli

> scan
> scan_results
> add_network
0
> set_network 0 ssid "NETWORKNAME"
OK
> set_network 0 psk "MYPASSWORD"
OK
> set_network 0 key_mgmt WPA-PSK
OK
> enable_network 0
OK
> quit
```

---

### **Phase 2: Partitioning and LUKS Encryption**

1.  **Partition the Disk:**
```bash
sudo gdisk <your-disk>
```
- Inside `gdisk`, enter in sequence: `o`, `y`, `n`, `1`, `[Enter]`, `+1G`, `ef00`, `n`, `2`, `[Enter]`, `[Enter]`, `[Enter]`, `w`, `y`.

2.  **Encrypt the Main Partition:** Let `<your-disk-p2>` be your second partition.
```bash
# Use strong, explicit cryptographic parameters
sudo cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha512 --pbkdf argon2id <your-disk-p2>
```

3.  **Backup LUKS Header (Critical Recovery Step):**
```bash
sudo cryptsetup luksHeaderBackup <your-disk-p2> --header-backup-file luks-header-backup.img
# Copy this file to multiple secure, offline locations.
```

4.  **Open the Encrypted Container:**
```bash
sudo cryptsetup open <your-disk-p2> crypted
```

---

### **Phase 3: BTRFS Filesystem and Subvolumes**

1.  **Format the Filesystems:** Let `<your-disk-p1>` be your first partition.
```bash
sudo mkfs.btrfs -L NIXROOT /dev/mapper/crypted
sudo mkfs.vfat -n NIXBOOT <your-disk-p1>
```

2.  **Create BTRFS Subvolumes:**
```bash
sudo mount /dev/disk/by-label/NIXROOT /mnt
sudo btrfs subvolume create /mnt/@{nix,persist,home,log}
sudo umount /mnt
```

---

### **Phase 4: Mounting for True Impermanence**

This is the core of the impermanent architecture.

1.  **Mount Root to RAM:**
```bash
sudo mount -t tmpfs none /mnt
```

2.  **Create Mount Points in RAM:**
```bash
sudo mkdir -p /mnt/{boot,nix,persist,etc/nixos}
```

3.  **Mount Physical Subvolumes:**
```bash
MOUNT_OPTS="compress=zstd,noatime"
sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
sudo mount -o subvol=@nix,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/nix
sudo mount -o subvol=@persist,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/persist

sudo mkdir -p /mnt/persist/var/log
sudo mkdir -p /mnt/persist/home

sudo mount -o subvol=@log,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/persist/var/log
sudo mount -o subvol=@home,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/persist/home
```

4.  **Persist Configuration for Installation:**
```bash
sudo mkdir -p /mnt/persist/etc/nixos
sudo mount -o bind /mnt/persist/etc/nixos /mnt/etc/nixos
```

5.  **Verify Mounts:** Run `findmnt --target /mnt`. Confirm `tmpfs` is on `/mnt` and that `/mnt/home` does not exist yet.

---

### **Phase 5: NixOS Configuration with Flakes**

1.  **Generate Base Config:**
```bash
sudo nixos-generate-config --root /mnt
```

2.  **Download Preliminary `.nix` Files**

```sh
curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/imperm-prelim.sh -o /mnt/persist/etc/nixos/imperm-prelim.sh

chmod +x /mnt/persist/etc/nixos/imperm-prelim.sh 
```

`imperm-prelim.sh`
```sh
cd /mnt/persist/etc/nixos
mv configuration.nix configuration.nix.BAK
mv hardware-configuration.nix hardware-configuration.nix.BAK

curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/configuration-STAGE1.nix -o /mnt/persist/etc/nixos/configuration.nix

curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/flake-STAGE1.nix -o /mnt/persist/etc/nixos/flake.nix

curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/profile/system/persist.nix -o /mnt/persist/etc/nixos/persist.nix

curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/profile/system/lanza.nix -o /mnt/persist/etc/nixos/lanza.nix

curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/profile/system/btrfs.nix -o /mnt/persist/etc/nixos/btrfs.nix
``` 

3.  **Edit `hardware-configuration.nix`:**
    *   **Delete** any existing `fileSystems` entries.
`sudo nano /mnt/etc/nixos/hardware-configuration.nix`
```nix
{

	imports = 
		[
		./btrfs.nix
		];
		
  # Get your LUKS partition UUID with: sudo blkid -s UUID -o value <your-disk-p2>
  # This may already be present -- verify it is correct
  
  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/YOUR-LUKS-PARTITION-UUID";

}
```

4.  **Edit `configuration.nix`:**
    *   **Remove** any `fileSystems` and `boot.initrd.luks` blocks.
    *   **Import** your `persistence.nix` file.
`sudo nano /mnt/etc/nixos/configuration.nix`
```nix
{ pkgs, ... }: {
	imports = [
	./hardware-configuration.nix
    ./persist.nix # This file now manages ALL persistent state
  ];

  # --- Security Hardening ---
  networking.firewall.enable = true;

  # --- Users ---
  users.users.changeme = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "asd";
  };
  
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
    
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  powerManagement.cpuFreqGovernor = "powersave";
      
  # --- Basic System Settings ---
  time.timeZone = "America/New_York";
  networking.hostName = "CHANGEMEBITCHPLEASE";
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [ 
	  neovim 
	  git 
	  sbctl
	  wget
	  curl
	  tree
 ];
  system.stateVersion = "25.05"; 
}
```

---

### **Phase 6: Installation and First Boot**

1.  **Install the System:**
```bash
sudo nixos-install --flake /mnt/persist/etc/nixos#laptop
```

2.  **Reboot:** 
``` sh
sudo mv /root/luks-header-backup.img /mnt/persist
sudo umount -R /mnt 
sudo cryptsetup close /dev/mapper/crypted
sudo reboot
```
- LUKS will (should) ask for your passphrase
---

### Phase 7: Stage 2 Install - Download Full System Config and Integrate Impermanence
0. Connect to Wifi (if needed)
```sh 
nmcli radio wifi on
nmcli dev wifi list
nmcli --ask dev wifi connect "NETWORDSSID"
```

1. Clone full system configuration repository:
```sh
git clone https://github.com/guiseppegnixon/mygnix.git ~/.nixfiles
cd ~/.nixfiles
rm -rfv .git
```

2. **REPLACE `~/.nixfiles/profile/system/hardware-configuration.nix` WITH `/persist/etc/nixos/hardware-configuration.nix`**
```sh
sudo cp /persist/etc/nixos/hardware-configuration.nix profile/system/hardware-configuration.nix
```
- ENSURE UUID IS CORRECT OR SYSTEM WILL NOT BOOT
3. Position stage2 files:
```sh
mv flake-STAGE2.nix flake.nix
mv configuration-STAGE2.nix profile/configuration.nix
mv profile/system/persist-STAGE2.nix profile/system/persist.nix
```
4. Edit `flake.nix` to change username, hostname, and email
5. Edit `profile/system/system.nix` to remove stray `boot.initrd.luks.devices` entry. 
6. Edit `profile/system/hardening/hardening.nix` to comment out `./dnscrypt-proxy.nix` entry. *Re-enable following full system install*
7. Install full system (sans secure boot)
```sh
sudo nixos-rebuild switch --flake .#[hostname]
```
- It may be beneficial to add `nix.settings.download-buffer-size = 524288000;` to `configuration.nix`

---
### Phase 8: Enable Lanzaboote and Implement Secure Boot

1. Prerequisites - UEFI must be enabled and the system must be installed with `systemd-boot` as the bootloader. Lanzaboote will be switched to following first reboot(s)
```sh
bootctl status
```
- current firmware needs to be UEFI; bootloader needs to be `systemd-boot`
- verify that `/boot` is identified as the ESP

2. Set BIOS Password

3. Create Keys
```sh
sudo sbctl create-keys
```

4. Position stage3 files:
```sh
mv flake-STAGE3.nix flake.nix
mv configuration-STAGE3.nix profile/configuration.nix
```

5. Edit `flake.nix` to change username, hostname, and email

6. Verify machine is ready for secure boot:
```sh
sudo sbctl verify
Verifying file database and EFI images in /boot...
✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
✓ /boot/EFI/Linux/nixos-generation-355.efi is signed
✓ /boot/EFI/Linux/nixos-generation-356.efi is signed
✗ /boot/EFI/nixos/0n01vj3mq06pc31i2yhxndvhv4kwl2vp-linux-6.1.3-bzImage.efi is not signed
✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
```
- `*bzImage.efi` files are expected to not be signed

7. Enable Secure Boot:
	1. Boot to BIOS
	2. Security > Secure Boot
	3. Reset to Setup Mode
		1. **DO NOT CLEAR ALL SECURE BOOT KEYS**

8. Enroll Keys:
	1. boot into system
	2. enroll keys:
```sh
sudo sbctl enroll-keys --microsoft
```

9. Reboot System:
	1. observe secure boot activation messages
	2. verify secure boot:
```
bootctl status
```
3. check the file size of `/sys/firmware/efi/efivars/dbx-*` to ensure they are not empty

---
### Phase 10: Unlocking LUKS with TPM2

1. Edit `lanza.nix` to install `tpm2-tss` and create a `systemd-cryptenroll` script
	1. alternatively, `mv -v profile/system/lanza-STAGE2.nix profile/system/lanza.nix`
```nix
{pkgs, lib, ... }:

let
  luksCryptenroller = pkgs.writeTextFile {
    name = "luksCryptenroller";
    destination = "/bin/luksCryptenroller";
    executable = true;

    # Note: You can hardcode additional LUKS devices like so:
    # text = let
    #   ...
    #   luksDevice02 = "BEEGLUKS01";
    #   luksDevice03 = "BEEGLUKS02";
    # in ''
    #   ...
    #   sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+7 /dev/disk/by-label/${luksDevice02}
    #   sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+7 /dev/disk/by-label/${luksDevice03}
    # '';

    text = let
      luksDevice01 = "NIXLUKS";
    in ''
      sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+7 /dev/disk/by-label/${luksDevice01}
    '';
  };
in
{
  environment.systemPackages = [
    luksCryptenroller
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
    # Needed to use the TPM2 chip with `systemd-cryptenroll`
    pkgs.tpm2-tss
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
```

2. Enroll the keys:
	1. If Step 1 was implemented properly, this is as simple as:
```sh
sudo nixos-rebuild switch --flake
luksCryptenroller
```

3. Reboot and Verify Proper Booting via TPM2
