#!/usr/bin/env bash

set -e

#--- PHASE 1 ---#
DISK="/dev/sda"

sgdisk --clear \
  -n 1:0:+1G  -t 1:ef00 \
  -n 2:0:0    -t 2:8300 \
  "$DISK"

#--- PHASE 2 ---#
cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha512 --pbkdf argon2id "$DISK"2

cryptsetup luksHeaderBackup "$DISK"2 --header-backup-file luks-header-backup.img

cryptsetup open "$DISK"2 crypted

#--- PHASE 3 ---#
mkfs.btrfs -L NIXROOT /dev/mapper/crypted
mkfs.vfat -n NIXBOOT "$DISK"1

mount /dev/disk/by-label/NIXROOT /mnt
btrfs subvolume create /mnt/@{nix,persist,home,log}
umount /mnt

#--- PHASE 4 ---#
mount -t tmpfs none /mnt
mkdir -pv /mnt/{boot,nix,persist,etc/nixos}

MOUNT_OPTS="compress=zstd,noatime"
sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
sudo mount -o subvol=@nix,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/nix
sudo mount -o subvol=@persist,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/persist

sudo mkdir -p /mnt/persist/var/log
sudo mkdir -p /mnt/persist/home

sudo mount -o subvol=@log,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/persist/var/log
sudo mount -o subvol=@home,$MOUNT_OPTS /dev/disk/by-label/NIXROOT /mnt/persist/home

sudo mkdir -p /mnt/persist/etc/nixos
sudo mount -o bind /mnt/persist/etc/nixos /mnt/etc/nixos

findmnt --target /mnt

#--- PHASE 5 ---#
nixos-generate-config --root /mnt

curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/imperm-prelim.sh -o /mnt/etc/nixos/imperm-prelim.sh

chmod +x /mnt/persist/etc/nixos/imperm-prelim.sh

/mnt/persist/etc/nixos/imperm-prelim.sh

vim /mnt/persist/etc/nixos/hardware-configuration.nix

#--- PHASE 6 ---#
nixos-install --flake /mnt/persist/etc/nixos#laptop

mv -v /root/luks-header-backup.img /mnt/persist
umount -R /mnt
cryptsetup close /dev/mapper/crypted

echo "Script Execution Complete. Reboot to Continue."
