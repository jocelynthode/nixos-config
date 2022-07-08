# NixOS Config

# Generate sops

## Generate PGP from SSH

```bash
nix develop
cp $HOME/.ssh/id_rsa /tmp/id_rsa
chmod u+w /tmp/id_rsa
ssh-keygen -p -N "" -f /tmp/id_rsa
ssh-to-pgp -private-key -i /tmp/id_rsa | gpg --import --quiet
rm /tmp/id_rsa
gpg --list-secret-keys
```

## Generate age key from ssh keys for new hosts

```bash
nix develop
ssh-to-age -i /persist/etc/ssh/ssh_host_ed25519_key.pub
```

## Add secrets

```bash
nix develop
sops path/to/file.yaml
```

SOPS Example

```yaml
hello: Welcome to SOPS! Edit this file as you please!
example_key: example_value
# Example comment
example_array:
  - example_value1
  - example_value2
example_number: 1234.56789
example_booleans:
  - true
  - false
```

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
./bootstrap.sh [--create-efi] --hostname=<hostname>--disk=/dev/to/disk
```

6. Setup additional secrets in `.sops.yaml` for new host

7. Setup new sops files

8. Reboot

## Rebuild

To rebuild after changes have made it to the repo use:

```bash
sudo nixos-rebuild switch --flake github:jocelynthode/nixos-config
```
