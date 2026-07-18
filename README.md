# NixOS Configuration

This repository contains the NixOS configuration for various machines, managed using flakes and a structured, dendritic layout.

## Architecture

This configuration follows a category-first, dendritic structure, leveraging `flake-parts` for modularity and the `aspects` system for high-level feature management.

### Flake Entry Points

- The `flake.nix` file serves as the primary entry point, importing `./parts` which orchestrates the loading of NixOS modules.

### Module Structure

- **Categories:** Modules are organized into top-level categories within the `modules/` directory (e.g., `modules/services/`, `modules/programs/`). Each category has a `default.nix` which acts as a flake-parts module.
- **Leaf Modules:** Specific features are defined in leaf modules within their respective categories (e.g., `modules/services/webserver/default.nix`). These are plain NixOS modules.
- **Discovery:** `flake-parts` is used with `import-tree.match` to automatically discover and import leaf modules within each category. This means adding a new feature typically only requires adding a new leaf module.

### The `aspects` System

- **Purpose:** Provides a centralized namespace (`options.aspects`) for enabling and configuring features across different machines. This simplifies enablement by offering high-level toggles (e.g., `aspects.games.steam.enable = true;`) instead of managing numerous individual NixOS options.
- **Usage:** Features are enabled by setting `aspects.<category>.<feature>.enable = true;` in the machine-specific configuration file (e.g., `machines/<hostname>/default.nix`).

### State Management with Impermanence

- This configuration utilizes the `impermanence` Nix module to manage state persistence, particularly for systems with ephemeral root filesystems (`tmpfs`).
- State is declared within modules that require it, using `aspects.base.persistence.homePaths` for user-specific paths and `aspects.base.persistence.systemPaths` for system-wide paths. This ensures only explicitly designated data survives reboots.

## Installation

1. Boot from the ISO.
2. Obtain the server's IP address and ensure root SSH access is enabled.
3. Run the bootstrap script with the appropriate parameters:
   ```bash
   ./bootstrap.sh --host <host> --ip <ip>
   ```
4. Commit any necessary `sops` changes.
5. Your machine should now be reachable.

### FIDO2 LUKS Enrollment (Encrypted Hosts)

After the initial boot on hosts with FIDO2 LUKS encryption (e.g., `frametek`), enroll your FIDO2 security keys:

```bash
# Enroll a YubiKey (repeat for each key, one at a time)
sudo systemd-cryptenroll --fido2-device=auto --fido2-with-client-pin=yes /dev/disk/by-label/<host>_crypt

# Enroll a recovery passphrase (store securely, e.g., in Bitwarden)
sudo systemd-cryptenroll --password /dev/disk/by-label/<host>_crypt
```

At boot, insert a registered YubiKey and touch it when prompted. If no key is present, it will fall back to the recovery passphrase.

## Rebuild

To apply changes after they have been merged into the repository:

```bash
sudo nixos-rebuild switch --flake github:jocelynthode/nixos-config
```

## Secrets Management

### Adding New Secrets

1. Enter the development environment:
   ```bash
   nix develop
   ```
2. Create or edit the secrets file (e.g., `hosts/common/secrets.yaml`):
   ```bash
   sops hosts/common/secrets.yaml
   ```

### Updating Secrets with New Keys

1. Generate an SSH key for `age` if needed:
   ```bash
   ssh-to-age -i /persist/etc/ssh/ssh_host_ed25519_key.pub
   ```
2. Update the secrets to use the new key:
   ```bash
   sops updatekeys secrets/**/*.yaml
   ```

## Building the Custom ISO

To build the custom NixOS installation ISO:

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
sudo dd if=result/iso/*.iso of=/dev/sdX status=progress
sync
```

## Inspiration

- [chvp config](https://github.com/chvp/nixos-config)
- [Misterio77 config](https://github.com/Misterio77/nix-config)
