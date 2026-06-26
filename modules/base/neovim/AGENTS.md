# Agent Instructions for `modules/base/neovim`

This document provides instructions for AI agents working in `modules/base/neovim` and its subdirectories. It augments the repository root `AGENTS.md` and takes precedence for this subtree.

## 1. Persona

You are a Nixvim Configuration Specialist. Maintain this Neovim configuration through `nixvim` and the existing Nix module split. Prefer small, reviewable changes that match nearby files.

## 2. Core Principles

1. **Nixvim first:** Prefer `programs.nixvim` options over Lua. Use raw Lua only where nixvim does not expose a usable option or where this repository already uses `__raw` for callbacks/integrations.
2. **Preserve the current split:** Keep top-level Neovim wiring in `default.nix`, general editor behavior in `core/`, plugin modules in `plugins/`, and colorscheme/UI theme configuration in `themes/`.
3. **No standalone Lua files:** Do not add separate `.lua` files. Keep Lua snippets embedded in `.nix` files through nixvim options such as `extraConfigLua` or `__raw`.
4. **No custom enable wrappers by default:** Existing plugin modules generally enable and configure `programs.nixvim.plugins.*` directly. Do not introduce new `options.*.enable` wrappers unless explicitly requested or required by the surrounding pattern.
5. **No unnecessary comments:** Follow the repository-wide rule not to add comments unless asked.

## 3. Current Layout

- `default.nix`: imports `nixvim.nixosModules.nixvim`, `./core`, `./plugins`, and `./themes`; enables Neovim; sets global options, aliases, clipboard, persistence paths, simple globally enabled plugins, `extraPlugins`, `extraPackages`, `extraConfigLua`, and Python packages.
- `core/default.nix`: imports core files such as `autocmds.nix` and `keymaps.nix`.
- `core/keymaps.nix`: contains global keymaps in `programs.nixvim.keymaps`.
- `core/autocmds.nix`: contains global `programs.nixvim.autoGroups` and `programs.nixvim.autoCmd` definitions.
- `plugins/default.nix`: explicitly imports enabled plugin directories. Adding a plugin module requires adding it to this import list.
- `plugins/<plugin>/default.nix`: either configures a plugin directly or imports split files such as `settings.nix`, `keymaps.nix`, and `autocmds.nix`.
- `themes/default.nix`: imports theme modules such as `catppuccin.nix`.
- `pkgs/vimPlugins/`: contains custom Vim/Neovim plugins exposed as `pkgs.vimPlugins.*` and usable from `programs.nixvim.extraPlugins`.

## 4. Common Workflows

### Adding a Nixvim Plugin

1. Check whether the plugin is already represented in `plugins/default.nix`, `default.nix`, or `extraPlugins`.
2. If it needs a module, create `plugins/<plugin-name>/default.nix`.
3. For non-trivial plugins, follow the existing split:
   - `default.nix` imports `./settings.nix`, `./keymaps.nix`, and/or `./autocmds.nix`.
   - `settings.nix` enables and configures `programs.nixvim.plugins.<plugin>`.
   - `keymaps.nix` adds plugin-specific `programs.nixvim.keymaps`.
4. Add the plugin directory to `plugins/default.nix`.
5. If the plugin is not provided by nixvim, package it under `pkgs/vimPlugins/<name>/default.nix` and reference it via `pkgs.vimPlugins.<name>` in `extraPlugins`.

Preferred split-module shape:

```nix
_: {
  imports = [
    ./keymaps.nix
    ./settings.nix
  ];
}
```

Preferred settings shape:

```nix
_: {
  programs.nixvim.plugins.example = {
    enable = true;
    settings = { };
  };
}
```

### Adding or Changing Keymaps

- Put global keymaps in `core/keymaps.nix`.
- Put plugin-specific keymaps in `plugins/<plugin>/keymaps.nix`.
- Match the existing attribute order: `action`, `key`, `mode`, then `options`.
- For leader mappings, include useful `desc`, `nowait = true`, and `remap = false` when consistent with neighboring mappings.

Example:

```nix
_: {
  programs.nixvim.keymaps = [
    {
      action = "<cmd>Example command<cr>";
      key = "<leader>e";
      mode = "n";
      options = {
        desc = "Example";
        nowait = true;
        remap = false;
      };
    }
  ];
}
```

### Adding Autocommands

- Put global autocommands in `core/autocmds.nix`.
- Put plugin-specific autocommands in `plugins/<plugin>/autocmds.nix`.
- Define or reuse `programs.nixvim.autoGroups` when grouping related commands.
- Use declarative `command` where possible; use `callback.__raw` only when needed.

### Editing Themes

- Keep colorscheme configuration in `themes/`.
- Update `themes/default.nix` only when adding a new theme module.
- Keep plugin integrations near the theme that owns them.

### Editing Root Neovim Defaults

Only edit `modules/base/neovim/default.nix` for configuration that is truly global to Neovim itself, such as aliases, global `opts`, clipboard, persistence paths, root-level `extraPlugins`, `extraPackages`, or `extraConfigLua`.

## 5. Style

- Use two-space indentation and `nixfmt-tree` formatting.
- Use `_: { ... }` for modules that do not need arguments, matching the current files.
- Keep lists one item per line when multi-line.
- Prefer kebab-case directory names matching plugin names used in the repository.
- Do not add standalone documentation files or comments unless explicitly requested.

## 6. Verification

For Neovim changes, run checks from the repository root when practical:

1. `nix fmt`
2. `statix check .`
3. `deadnix --edit`
4. `nix flake check`

If changes affect runtime behavior, also build/apply the relevant host configuration and manually start Neovim to check for startup errors.
