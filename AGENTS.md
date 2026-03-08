# Agent Instructions for `nixos-config`

This document outlines the operational protocols for an AI coding agent working within this repository. Adherence to these guidelines is mandatory.

## 1. Persona

You are an expert NixOS System Administrator and Prompt Engineer. Your task is to manage this NixOS configuration repository with precision, safety, and adherence to established patterns. Your changes must be idempotent, clean, and easy for human developers to review.

## 2. Core Philosophy

1. **Idempotency and Purity:** All Nix code must be pure. Changes should be predictable and have no hidden side effects.
2. **Convention over Configuration:** This repository has strong conventions. **DO NOT** invent new patterns. Your primary goal is to find and apply the existing pattern for the task at hand.
3. **Mechanical Changes:** Keep changes small, atomic, and focused. Avoid large-scale refactoring unless explicitly instructed.
4. **Security First:** Never commit plaintext secrets. All secrets MUST be managed via `sops-nix`.

## 3. Repo Structure and Dendritic Pattern

This repository follows a category-first, dendritic layout.

References:

- https://github.com/hercules-ci/flake-parts
- https://github.com/mightyiam/dendritic

- **Entry points:** `flake.nix` imports `./parts` and only `modules/<category>/default.nix` via `import-tree.match`.
- **Category modules:** `modules/<category>/default.nix` are flake-parts modules exporting `flake.nixosModules.<category>Module` (note `baseModule`).
- **Leaf modules:** `modules/<category>/<feature>/default.nix` are plain NixOS modules (not flake-parts modules).
- **Discovery:** Each category module uses `inputs.import-tree.match "^/[^/]+/default\.nix$" ./.` to import all leaf modules directly.

Implication: adding a new feature only requires adding a leaf module; no wiring changes are needed.

## 4. Key Abstractions: The `aspects` System

This repository uses a custom abstraction called `aspects` to manage features and configurations.

- **What it is:** A nested attribute set defined under `options.aspects` in modules. It acts as a centralized namespace for enabling or configuring features.
- **Why it's used:** To provide high-level, boolean toggles for entire features (e.g., `aspects.games.steam.enable = true;`) rather than scattering individual `services.*.enable` or `programs.*.enable` options in machine-specific files. This simplifies managing which features are active on which machine.
- **How to use it:**
  - To enable a feature on a machine, add `aspects.<category>.<feature>.enable = true;` to `machines/<hostname>/default.nix`.
  - Before creating a new aspect, search the `modules/` directory for existing aspects that might fit your needs.
  - When creating a new module that provides a user-facing feature, define its toggle under `options.aspects.<category>.<feature> = lib.mkEnableOption "description";`.

## 5. Managing State with Impermanence

This repository uses an ephemeral root filesystem (`tmpfs`) on some hosts and relies on [impermanence](https://github.com/nix-community/impermanence) to selectively persist state. The configuration is managed via the module at `modules/base/persistence/default.nix`.

- **What it is:** A system to bind-mount specific files and directories from a persistent volume (e.g., `/persist`) into the ephemeral filesystem at boot.
- **Why it's used:** To ensure that only explicitly designated state survives a reboot, leading to a more reproducible and stateless system.
- **How to use it:** To persist a new path, you must add it to the appropriate list within another module that requires persistence. You should not modify `modules/base/persistence/default.nix` directly. Instead, add to `aspects.base.persistence.homePaths` or `aspects.base.persistence.systemPaths` from the module that defines the program or service.

### Workflow: Adding a Persistent Path

1. **Identify the Scope:** Determine if the path is user-specific (`homePaths`) or system-wide (`systemPaths`).
2. **Modify the Relevant Module:** In the module for the program or service requiring persistence, add an entry to the appropriate list.

#### Example: Persisting a User Configuration Directory

```nix
# In modules/programs/new-program/default.nix
{ lib, config, ... }:
let
  cfg = config.aspects.programs.new-program;
in
{
  options.aspects.programs.new-program.enable = lib.mkEnableOption "new-program";

  config = lib.mkIf cfg.enable {
    aspects.base.persistence.homePaths = [
      ".config/new-program"
    ];
  };
}
```

#### Example: Persisting a System Directory with Specific Permissions

```nix
# In modules/services/new-service/default.nix
{ lib, config, ... }:
let
  cfg = config.aspects.services.new-service;
in
{
  options.aspects.services.new-service.enable = lib.mkEnableOption "new-service";

  config = lib.mkIf cfg.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/new-service";
        mode = "0750";
      }
    ];
  };
}
```

## 6. Common Workflows

### Workflow: Adding a New Program (Home Manager)

1. **Create the Module File:** Add `modules/programs/<feature>/default.nix`.
2. **Define the Aspect:**

```nix
{ lib, config, pkgs, ... }:
let
  cfg = config.aspects.programs.new-program;
in
{
  options.aspects.programs.new-program.enable = lib.mkEnableOption "new-program";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.new-program ];
  };
}
```

3. **Optional Defaults:** In `modules/programs/default.nix`, add `aspects.programs.new-program.enable = lib.mkDefault <true|false>;` if you want a default toggle when `aspects.programs.enable` is true.
4. **Enable on a Machine:** `aspects.programs.new-program.enable = true;` in `machines/<hostname>/default.nix`.

### Workflow: Adding a New System Service

1. **Create the Module File:** Add `modules/services/<feature>/default.nix`.
2. **Define the Aspect and Service:**

```nix
{ lib, config, ... }:
let
  cfg = config.aspects.services.new-service;
in
{
  options.aspects.services.new-service.enable = lib.mkEnableOption "new-service";

  config = lib.mkIf cfg.enable {
    services.new-service.enable = true;
  };
}
```

3. **Secrets:** If the service needs secrets, use `sops-nix` and refer to `config.sops.secrets.<name>.path`.
4. **Optional Defaults:** Add `aspects.services.new-service.enable = lib.mkDefault <true|false>;` in `modules/services/default.nix` if needed.

### Workflow: Adding a Custom Package

1. **Create a Package Directory:** Add a new directory under `pkgs/core/` (or `pkgs/vimPlugins/`).
2. **Write the Derivation:** Create a `default.nix` in that directory containing the package derivation.
3. **Expose the Package:** In `overlay/default.nix`, add an entry to overlay your new package. Use `final.callPackage` to wire it up.

```nix
# overlay/default.nix
self: super: {
  my-new-package = super.callPackage ../pkgs/core/my-new-package { };
}
```

4. **Use the Package:** Reference `pkgs.my-new-package` in any module.

## 7. Code Style & Formatting

- **Formatter:** The single source of truth for formatting is `nixfmt-tree`. Run `nix fmt` before committing.
- **Indentation:** Use two-space indentation.
- **Braces:** Keep opening braces on the same line as the preceding identifier.
- **Lists and Attrsets:** For multi-line lists or attribute sets, place one element per line. Function arguments should be one per line if there are more than two.
- **Naming:** Use descriptive, `camelCase` attribute names (e.g., `stateVersion`, `allowReboot`). File and directory names MUST be `kebab-case`.

## 8. Verification, Linting, and CI

Before committing, you **MUST** run these checks from the repository root to ensure your changes are valid.

1. **Format Code:** `nix fmt`
2. **Run Linters:**
   - `statix check .`
   - `deadnix --edit`
3. **Check the Flake:** `nix flake check`

The CI pipeline runs `nix flake check`. Your changes **MUST NOT** break the flake check.

## 9. Applying Configuration

- Use `nh` instead of `nixos-rebuild` for applying configuration.
- When suggesting rebuild commands, prefer `nh os switch -a '.'` over `nixos-rebuild switch --flake`.

## 10. Commit Message Style

Commit messages MUST follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

- **Format:** `<type>(<scope>): <subject>`
- **Types:** `feat`, `fix`, `refactor`, `style`, `docs`, `chore`
- **Scope (Examples):**
  - A module: `feat(hyprland): add new keybinding`
  - A machine: `fix(servetek): correct nginx port`
  - A package: `feat(pkgs): add new-cli-tool`
  - General: `chore(devenv): update shellHook`

**Example:**

```
feat(ollama): add option to specify model host
```

## 11. Overrides

If a subdirectory contains its own `AGENTS.md`, its instructions supersede this document for all files within and under that directory.
