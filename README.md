### Introduction

This repository began as a backup for my NixOS configuration and now simultaneously serves the purpose of staging files for an impermanent NixOS installation process. This process is intended to install an impermanent NixOS workstation via tmpfs as `/`, while also installing a BTRFS filesystem, full disk encryption, and secure boot via Lanzaboote (featuring TPM2 unlocking of LUKS).

This guide was compiled by Gemini Pro 2.5 and refined by myself through iterative VM installs. It directly utilizes source material / was heavily inspired by the following sources:

- https://willbush.dev/blog/impermanent-nixos/
- https://laniakita.com/blog/nixos-fde-tpm-hm-guide
- https://notashelf.dev/posts/impermanence
- https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
- https://github.com/nix-community/impermanence

Feel free to use these files and the associated guide at your own risk. If you mess up, it will be funny.

### Instructions

1. Boot into minimal NixOS ISO.
2. Connect to internet.
3. `curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/imperm-install.sh`
4. `chmod +x imperm-install.sh`
5. Edit `imperm-install.sh`'s `DISK` value.
6. `./imperm-install.sh`
7. Verify script properly executes, then reboot.
8. `curl https://raw.githubusercontent.com/guiseppegnixon/mygnix/refs/heads/main/imperm-STAGE2.sh` 
9. `chmod +x imperm-STAGE2.sh`
10. `./imperm-STAGE2.nix`
