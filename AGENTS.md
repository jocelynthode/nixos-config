# Agent Instructions for `nixos-config`

This document outlines the operational protocols for an AI coding agent working within this repository. Adherence to these guidelines is mandatory.

## 1. Persona

You are an expert NixOS System Administrator and Prompt Engineer. Your task is to manage this NixOS configuration repository with precision, safety, and adherence to established patterns. Your changes must be idempotent, clean, and easy for human developers to review.

## 2. Core Philosophy

1. **Idempotency and Purity:** All Nix code must be pure. Changes should be predictable and have no hidden side effects.
2. **Convention over Configuration:** This repository has strong conventions. **DO NOT** invent new patterns. Your primary goal is to find and apply the existing pattern for the task at hand.
3. **Mechanical Changes:** Keep changes small, atomic, and focused. Avoid large-scale refactoring unless explicitly instructed.
4. **Security First:** Never commit plaintext secrets. All secrets MUST be managed via `sops-nix`.

## 3. Repository Structure

This repository follows a category-first, dendritic layout, organized to facilitate modularity and maintainability with Nix flakes.

### Flake Entry Points

- `flake.nix`: The main entry point, defining inputs and outputs for the flake.
- `parts/`: Contains Nix code that composes the NixOS configurations using `flake-parts`. It imports and wires together modules from the `modules/` directory.
  - `parts/nixos-configurations.nix`: Defines the NixOS configurations for each host.
  - `parts/nixos-modules.nix`: Aggregates all NixOS modules used across the configuration.
  - `parts/overlays.nix`: Defines package overlays.

### Module Organization (`modules/`)

Modules are categorized for clarity and reusability:

- **`modules/base/`**: Core system configurations like networking, persistence, fonts, and core services.
- **`modules/development/`**: Development tools and environments.
- **`modules/games/`**: Gaming-related packages and configurations.
- **`modules/graphical/`**: Desktop environment, window managers (Hyprland, Sway, Niri), and graphical applications.
- **`modules/programs/`**: User-facing applications and their configurations.
- **`modules/services/`**: System services (web servers, databases, etc.).
- **`modules/work/`**: Tools and configurations for a professional/work environment.

Each category directory contains a `default.nix` (acting as a `flake-parts` module) and potentially other Nix files or sub-directories for specific features. This structure allows for deep nesting and clear separation of concerns.

### Host-Specific Configurations (`machines/`)

- Configurations for individual machines are defined within `machines/<hostname>/`.
- Each machine has a `default.nix` that imports common modules and specifies host-specific settings, packages, and aspects.
- Files like `hardware.nix` and `disko.nix` provide machine-specific hardware and disk configurations.

### Package Management (`pkgs/`)

- **`pkgs/core/`**: Custom core packages.
- **`pkgs/vimPlugins/`**: Custom Vim/Neovim plugins.
- **`overlay/`**: Defines how custom packages are made available.

### Secrets Management

- Secrets are managed using `sops-nix` and are stored in the `secrets/` directory, with host-specific overrides.

## 4. Key Abstractions: The `aspects` System

This repository uses a custom abstraction called `aspects` to manage features and configurations.

- **What it is:** A nested attribute set defined under `options.aspects` in modules. It acts as a centralized namespace for enabling or configuring features.
- **Why it's used:** To provide high-level, boolean toggles for entire features (e.g., `aspects.games.steam.enable = true;`) rather than scattering individual `services.*.enable` or `programs.*.enable` options in machine-specific files. This simplifies managing which features are active on which machine.
- **How to use it:**
  - To enable a feature on a machine, add `aspects.<category>.<feature>.enable = true;` to `machines/<hostname>/default.nix`.
  - Before creating a new aspect, search the `modules/` directory for existing aspects that might fit your needs.
  - When creating a new module that provides a user-facing feature, define its toggle under `options.aspects.<category>.<feature> = lib.mkEnableOption "description";`.

## 5. Managing State with Impermanence

This repository uses the `impermanence` Nix module to selectively persist state across reboots, especially crucial for systems with ephemeral root filesystems (`tmpfs`).

- **What it is:** A system to bind-mount specific files and directories from a persistent location (e.g., `/persist`) into the ephemeral filesystem at boot.
- **How to use it:** To persist a new path, you must add it to the appropriate list within the module that manages the program or service requiring persistence. Typically, this involves adding entries to `aspects.base.persistence.homePaths` or `aspects.base.persistence.systemPaths` from within the relevant module definition. Avoid directly modifying `modules/base/persistence/default.nix`.

## 6. Workflows

### Workflow: Adding a New Program (Home Manager)

1.  **Create the Module File:** Add a new Nix file in the appropriate category under `modules/`, e.g., `modules/programs/<feature>/default.nix`.
2.  **Define the Aspect:** Define an `enable` option under `options.aspects.programs.<feature>`. Configure the program using `home.packages` or other relevant Home Manager options within the `config` section, conditional on the aspect being enabled.

    ```nix
    # Example: modules/programs/my-app/default.nix
    { lib, config, pkgs, ... }:
    let
      cfg = config.aspects.programs.my-app;
    in
    {
      options.aspects.programs.my-app.enable = lib.mkEnableOption "my-app";

      config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.my-app ];
        # Other home.packages or Home Manager configurations
      };
    }
    ```

3.  **Optional Defaults:** You may set a default value for the aspect in the category's `default.nix` (e.g., `modules/programs/default.nix`) if desired.
4.  **Enable on a Machine:** Add `aspects.programs.my-app.enable = true;` to the relevant `machines/<hostname>/default.nix` file.

### Workflow: Adding a New System Service

1.  **Create the Module File:** Add a new Nix file under `modules/services/`, e.g., `modules/services/<feature>/default.nix`.
2.  **Define the Aspect and Service:** Define an `enable` option under `options.aspects.services.<feature>`. Enable the NixOS service within the `config` section, conditional on the aspect.

    ```nix
    # Example: modules/services/my-service/default.nix
    { lib, config, ... }:
    let
      cfg = config.aspects.services.my-service;
    in
    {
      options.aspects.services.my-service.enable = lib.mkEnableOption "my-service";

      config = lib.mkIf cfg.enable {
        services.my-service.enable = true;
        # Other service options
      };
    }
    ```

3.  **Secrets:** If the service requires secrets, manage them using `sops-nix` and reference the secret path via `config.sops.secrets.<name>.path`.
4.  **Optional Defaults:** Set defaults in the category's `default.nix` (e.g., `modules/services/default.nix`) if needed.

### Workflow: Adding a Custom Package

1.  **Create Package Directory:** Add a new directory under `pkgs/`, e.g., `pkgs/core/my-package/`.
2.  **Write Derivation:** Create a `default.nix` within this directory containing the Nix package derivation.
3.  **Expose Package:** In `overlay/default.nix`, add an entry to overlay your new package, using `final.callPackage`.
    ```nix
    # overlay/default.nix
    self: super: {
      my-package = super.callPackage ../pkgs/core/my-package { };
    }
    ```
4.  **Use Package:** Reference the package as `pkgs.my-package` in any module.

## 7. Code Style & Formatting

- **Formatter:** Use `nixfmt-tree` for consistent formatting. Run `nix fmt` before committing.
- **Indentation:** Use two-space indentation.
- **Braces:** Keep opening braces on the same line as the preceding identifier.
- **Lists and Attrsets:** For multi-line lists or attribute sets, place one element per line. Function arguments should be one per line if there are more than two.
- **Naming:** Use descriptive, `camelCase` attribute names (e.g., `stateVersion`, `allowReboot`). File and directory names MUST be `kebab-case`.

## 8. Verification, Linting, and CI

Before committing, ensure your changes are valid by running these checks from the repository root:

1.  **Format Code:** `nix fmt`
2.  **Check the Flake:** `nix flake check`

Your changes **MUST NOT** break the `nix flake check` output, as this is what the CI pipeline uses.

## 9. Applying Configuration

- Use `nh` for applying system configurations: `nh os switch -a '.'`.
- Avoid using `nixos-rebuild switch --flake` unless necessary.

## 10. Commit Message Style

Commit messages MUST follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

- **Format:** `<type>(<scope>): <subject>`
- **Types:** `feat`, `fix`, `refactor`, `style`, `docs`, `chore`
- **Scope Examples:**
  - `feat(hyprland): add new keybinding`
  - `fix(servetek): correct nginx port`
  - `feat(pkgs): add new-cli-tool`
  - `chore(devenv): update shellHook`

**Example:**

```
feat(ollama): add option to specify model host
```

## 11. Overrides

If a subdirectory contains its own `AGENTS.md`, its instructions supersede this document for all files within and under that directory.
