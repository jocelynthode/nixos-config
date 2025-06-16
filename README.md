# NixOS Config

# Install

1. Boot on the ISO
2. Get the IP of the server and make sure ssh via root works
3. Run bootstrap with the correct parameter

```bash
./bootstrap.sh --host <host> --ip <ip>
```

4. Commit the sops changes
5. Your vm should be reachable normally now

## Rebuild

To rebuild after changes have made it to the repo use:

```bash
sudo nixos-rebuild switch --flake github:jocelynthode/nixos-config
```

# Secrets

## Add new secrets

```bash
nix develop
# Then create file
sops hosts/common/secrets.yaml
```

## Update secrest for new key

```bash

# Add result to .sops.yaml
ssh-to-age -i /persist/etc/ssh/ssh_host_ed25519_key.pub

sops updatekeys secrets/**/*.yaml
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

# Inspiration

- [chvp config](https://github.com/chvp/nixos-config)

- [Misterio77 config](https://github.com/Misterio77/nix-config)
