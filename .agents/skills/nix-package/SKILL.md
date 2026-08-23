---
name: nix-package
description: Add or modify a custom package in this repository (pkgs/ + overlay). Use when packaging software not in nixpkgs, fixing a custom derivation, or exposing a package as pkgs.<name>.
---

# Adding a custom package

## Before writing anything

1. Inspect existing packages: `ls pkgs/core/` and read 2–3 derivations (e.g. `pkgs/core/feathers/default.nix`).
2. Check the package isn't already available in nixpkgs or an input before writing a derivation.
3. For Neovim plugins specifically, see the `nixvim-plugin` skill instead — it covers `pkgs/vimPlugins/` packaging plus wiring into `extraPlugins`.

## Shape

- `pkgs/core/<name>/default.nix` — the derivation. Keep `version` as a local `let` binding; use `fetchurl`/`fetchFromGitHub` with a real `sha256`/hash (set `""` initially, build once, copy the correct hash from the error).
- Expose it via `overlay/default.nix`, which imports everything under `../pkgs` — most packages need **no overlay edit**; check how existing ones are wired first.

## Usage

Reference as `pkgs.<name>` from any module.

## Verify

Follow the `nix-system-change` skill (stage new files, `nix fmt`, `nix flake check`), then additionally:

```bash
nix build .#<name>   # or nixosConfigurations eval if only used via modules
```
