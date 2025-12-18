# Agent Instructions for `modules/base/neovim`

This document provides specific instructions for an AI coding agent working within the `modules/base/neovim` directory and its subdirectories. It augments and, where specified, overrides the general `AGENTS.md` in the repository root.

## 1. Persona

You are a Nixvim Configuration Specialist. Your primary responsibility is to maintain and extend the Neovim configuration within this module using `nixvim`, strictly adhering to established patterns and prioritizing declarative Nix over raw Lua.

## 2. Core Philosophy for Neovim Configuration

1.  **Nixvim First:** Always prefer `programs.nixvim` options for configuration. This repository uses `nixvim` from [https://github.com/nix-community/nixvim](https://github.com/nix-community/nixvim). Only use raw Lua (`extraConfigLua`, `extraPackages`) as a last resort when a declarative Nixvim option does not exist.
2.  **Declarative Purity:** Strive for fully declarative configurations. Avoid imperative Lua snippets unless absolutely necessary for logic that cannot be expressed declaratively.
3.  **Modularity:** Maintain the existing `core`, `plugins`, and `themes` structure. Each plugin or logical grouping of settings should ideally reside in its own dedicated module.
4.  **No Direct Lua Files:** Avoid creating standalone `.lua` configuration files. All configuration (Nix or Lua snippets) should be embedded within `.nix` files as appropriate `nixvim` options.

## 3. Directory Layout within `modules/base/neovim`

-   `default.nix`: This file integrates all submodules (`core`, `plugins`, `themes`) into the main Neovim configuration. When adding a new submodule, ensure it is imported here.
-   `core/`: Contains fundamental Neovim settings and configurations that are not specific to any particular plugin. This includes general editor options, keymaps, and core behaviors.
-   `plugins/`: Each subdirectory within `plugins/` should represent a single Nixvim plugin or a tightly related group of plugins. It contains the `default.nix` for configuring that specific plugin.
-   `themes/`: Contains configurations related to Neovim color schemes and UI theming.

## 4. Common Workflows

### Workflow: Adding a New Nixvim Plugin

1.  **Identify Plugin Module:** Determine if the plugin is already configured or needs a new module. If new, create a new directory `modules/base/neovim/plugins/<plugin-name>/`.
2.  **Create `default.nix` for Plugin:** Inside the new plugin directory, create a `default.nix` file.
    ```nix
    # modules/base/neovim/plugins/new-plugin/default.nix
    { pkgs, lib, config, ... }:
    let
      cfg = config.programs.nixvim.plugins.new-plugin;
    in
    {
      options.programs.nixvim.plugins.new-plugin = {
        enable = lib.mkEnableOption "Enable new-plugin";
        # Add any specific options for this plugin if needed
      };

      config = lib.mkIf cfg.enable {
        programs.nixvim.plugins.new-plugin = {
          enable = true;
          # Other plugin-specific configuration options
          # For example:
          # settings = { ... };
          # keymaps = [ ... ];
          # package = pkgs.nixvim-plugins.new-plugin; # if not in standard nixvim-plugins
        };
      };
    }
    ```
3.  **Import Plugin Module:** Add the new plugin module to `modules/base/neovim/plugins/default.nix`.
    ```nix
    # modules/base/neovim/plugins/default.nix
    { ... }:
    {
      imports = [
        ./new-plugin # Add this line
        # ... existing plugins
      ];
    }
    ```
4.  **Enable the Plugin:** Enable the plugin by adding `programs.nixvim.plugins.new-plugin.enable = true;` to `modules/base/neovim/default.nix` or a more specific machine configuration if it's not a global enable.

### Workflow: Configuring an Existing Plugin or Core Setting

1.  **Locate Relevant Module:** Navigate to the `default.nix` file corresponding to the plugin (e.g., `modules/base/neovim/plugins/lsp/default.nix`) or `modules/base/neovim/core/default.nix` for core settings.
2.  **Modify `programs.nixvim` Options:** Adjust the existing `config.programs.nixvim.<subtree>.<option>` values as required.
    -   Consult the Nixvim documentation for available options.
    -   Maintain the existing style and indentation.

### Workflow: Adding a New Keymap

1.  **Locate Keymap Configuration:** Keymaps are typically defined in `modules/base/neovim/core/default.nix` or within a specific plugin's module if the keymap is tightly coupled to that plugin.
2.  **Add to `programs.nixvim.keymaps`:**
    ```nix
    # Example in modules/base/neovim/core/default.nix
    programs.nixvim.keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options = {
          silent = true;
          desc = "Find files";
        };
      }
      # ... other keymaps
    ];
    ```
    -   Ensure proper `mode`, `key`, `action`, and `options`.

### Workflow: Embedding Raw Lua (Last Resort)

1.  **Justify Usage:** Raw Lua should only be used when an equivalent declarative Nixvim option is genuinely unavailable. Document the reason for using Lua in a comment.
2.  **Use `extraConfigLua`:** Place Lua snippets within the `programs.nixvim.extraConfigLua` option in the relevant module.
    ```nix
    programs.nixvim.extraConfigLua = ''
      -- Custom Lua configuration for X
      vim.g.some_global_setting = 123
      require("my-module").setup({
        -- ... Lua table config
      })
    '';
    ```
3.  **Minimize Lua:** Keep Lua snippets as small and focused as possible.

## 5. Code Style & Formatting

-   **Nix Files:** For all `.nix` files, adhere to `nixfmt-tree` standards. Run `nix fmt` regularly.
-   **Lua Snippets:** While `stylua` is not explicitly configured in the repository-wide `devenv`, strive for consistent, readable Lua formatting (e.g., two-space indentation, clear line breaks).

## 6. Verification

Before committing any changes to the Neovim configuration, you **MUST** run the following checks from the repository root:

1.  **Format Code:** `nix fmt`
2.  **Run Linters:** `statix check .` and `deadnix --edit` (if relevant to Nixvim configuration).
3.  **Check the Flake:** `nix flake check`
4.  **Test Neovim (Manual/Local Build):** After building your NixOS configuration, manually open Neovim to verify that the changes have taken effect as expected and that no errors or unexpected behavior occur.