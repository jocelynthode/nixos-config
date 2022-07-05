# NixOS Config

# Install

1. Get the [NixOS](https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso)
2. Copy the Installer to a USB Stick:

```bash
sudo cp /path/to/iso /dev/to/disk
```

3. Boot on the ISO
4. Setup your partition

```bash
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- mkpart primary 512MiB 100%
parted /dev/sda -- set 1 esp on
mkfs.vfat -n BOOT /dev/sda1
mkfs.btrfs -L root /dev/sda2
```

5. Mount your partition on /mnt

```
mkdir -p /mnt
mount -t btrfs /dev/disk/by-label/root /mnt
cd /mnt/
btrfs subvolume create @
btrfs subvolume create @blank
btrfs property set -ts @blank ro true
btrfs subvolume create @nix
btrfs subvolume create @persist
btrfs subvolume create @log
btrfs subvolume create @swap
chattr +C /mnt/@swap
cd /
umount /mnt
mount -t btrfs -o subvol=@ /dev/disk/by-label/root /mnt
mkdir -p /mnt/nix
mkdir -p /mnt/persist
mkdir -p /mnt/var/log
mkdir -p /mnt/swap
mkdir -p /mnt/boot/efi
mount -t btrfs -o subvol=@nix /dev/disk/by-label/root /mnt/nix
mount -t btrfs -o subvol=@persist /dev/disk/by-label/root /mnt/persist
mount -t btrfs -o subvol=@log /dev/disk/by-label/root /mnt/var/log
mount -t btrfs -o subvol=@swap /dev/disk/by-label/root /mnt/swap
mount /dev/disk/by-label/EFI /mnt/boot/efi

dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=32768 status=progress
chmod 0600 /mnt/swap/swapfile
mkswap -L swap /mnt/swap/swapfile

```

6. Install This flake

```bash
nixos-install --no-root-password --no-channel-copy --flake github:jocelynthode/nixos-config#somehost

```

7. Reboot

## Rebuild

To rebuild after changes have made it to the repo use:

```bash
sudo nixos-rebuild switch --flake github:jocelynthode/nixos-config
```
