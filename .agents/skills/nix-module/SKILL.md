---
name: nix-module
description: Add or modify a NixOS program or service module in this repository using the aspects pattern. Use when creating a new feature module under modules/ (programs, services, base, development, games, graphical, work) or enabling an existing aspect on a machine. For Neovim plugin modules under modules/base/neovim/plugins/, use the nixvim-plugin skill instead.
---

# Adding a NixOS module

## Before writing anything

1. Find at least 2–3 existing modules in the same category and follow their exact pattern. The repository is convention-driven; real examples are the spec.
   - Programs: `modules/programs/git/default.nix`, `modules/programs/gh/default.nix`
   - Services: `modules/services/acme/default.nix`, `modules/services/actual/default.nix`
2. Check whether an aspect for the feature already exists (`grep -r "aspects\." modules/`) before defining a new one.

## Program module (home-manager) shape

```nix
{
  config,
  lib,
  ...
}:
{
  options.aspects.programs.<feature>.enable = lib.mkEnableOption "<feature>";

  config = lib.mkIf config.aspects.programs.<feature>.enable {
    home-manager.users.jocelyn = _: {
      # programs.<feature>.enable / home.packages / xdg.configFile ...
    };
  };
}
```

## Service module (NixOS) shape

Same skeleton with `options.aspects.services.<feature>.enable`; configure `services.<feature>` and any system-level options in the `config` block.

## Wiring checklist

- Category `default.nix`: add `<feature>.enable = lib.mkDefault <bool>;` under the category's defaults block.
- Machine: enable via `aspects.<category>.<feature>.enable` in `machines/<hostname>/default.nix` — never raw `services.*` options there.
- Persistence: if the feature stores state, add paths to `aspects.base.persistence.homePaths` / `systemPaths` from within the new module (see `modules/development/ai/pi/default.nix`). Do not edit `modules/base/persistence/default.nix`.
- Secrets: declare `sops.secrets` inside the consuming module; double-check relative `sopsFile` paths — they break silently when modules move directories.

## Import-tree gotcha

Category `default.nix` files auto-import only one level (`import-tree.match "^/[^/]+/default\.nix$"`). If you nest a module deeper (e.g. `modules/development/ai/mcp/`), the intermediate `default.nix` must import it explicitly (see `modules/development/ai/default.nix`).

## Verify

```bash
nix fmt
nix flake check
```

Then follow the `nix-system-change` skill for the full workflow (staging new files, targeted evals, applying).

Optionally sanity-check evaluation: `nix eval .#nixosConfigurations.<host>.config.aspects.<category>.<feature>.enable`
