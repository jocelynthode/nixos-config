# NixOS Config

# Install

1. Get the [NixOS](https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso)
2. Copy the Installer to a USB Stick:

```bash
sudo cp /path/to/iso /dev/to/disk
```

3. Boot on the ISO
4. Clone this repository

```bash
git clone https://github.com/jocelynthode/nixos-config
cd nixos-config
```

5. Run bootstrap.sh

```bash
nix develop
# This will wipe the disk and create a bootloader
./bootstrap.sh [--encrypt-root] --hostname=<hostname> --disk=/dev/to/disk
```

6. Setup additional secrets in `secrets.nix` for new host

7. Setup new age file if needed

8. Rekey your secrets

9. Bootstrap system

```bash
nixos-install --no-root-password --flake ".#<hostname>"

umount -R /mnt
# if needed
cryptsetup close <hostname>
```

10. Reboot

## Rebuild

To rebuild after changes have made it to the repo use:

```bash
sudo nixos-rebuild switch --flake github:jocelynthode/nixos-config
```

# Secrets

## Add new secrets

```bash
nix develop
ragenix -e file.age
```

## Rekey files after new users and/or host

```bash
nix develop
cd hosts/common/secrets
ragenix --rekey
```

# Build ISO

To Build the custom iso run the following commands:

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
dd if=result/iso/*.iso of=/dev/sdX status=progress
sync

```

# Showcase

![fakebusy](https://i.imgur.com/wmurHSd.png)
