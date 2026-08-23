---
name: nixvim-plugin
description: Add or modify a Neovim plugin module in modules/base/neovim/plugins/ of this repository. Use when adding a new plugin, splitting plugin config into settings/keymaps/autocmds files, or packaging a custom Vim plugin under pkgs/vimPlugins.
---

# Adding or modifying a Nixvim plugin

## Before writing anything

1. Read 2–3 existing plugin modules in `modules/base/neovim/plugins/` and match their pattern exactly.
2. Check whether the plugin is already configured in `plugins/default.nix`, the root `default.nix`, or `extraPlugins`.

## Adding a new plugin

1. Create `plugins/<plugin-name>/default.nix` (kebab-case, matching the plugin name).
2. For non-trivial plugins, use the split:

   ```nix
   _: {
     imports = [
       ./keymaps.nix
       ./settings.nix
     ];
   }
   ```

   - `settings.nix`: `programs.nixvim.plugins.<plugin> = { enable = true; settings = { }; };`
   - `keymaps.nix`: plugin-specific `programs.nixvim.keymaps`.
   - `autocmds.nix`: plugin-specific `autoGroups` + `autoCmd`; prefer declarative `command`, use `callback.__raw` only when needed.

3. Register the directory in `plugins/default.nix` (explicit import list — it does not auto-discover).
4. If nixvim doesn't provide the plugin: package it under `pkgs/vimPlugins/<name>/default.nix` (see the `nix-package` skill) and reference via `pkgs.vimPlugins.<name>` in `extraPlugins`.

## Keymap shape

Attribute order matters: `action`, `key`, `mode`, then `options`. Leader mappings get a useful `desc`, plus `nowait = true` / `remap = false` when neighboring mappings do.

```nix
_: {
  programs.nixvim.keymaps = [
    {
      action = "<cmd>Example<cr>";
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

## Placement rules

- Global keymaps → `core/keymaps.nix`; global autocommands → `core/autocmds.nix`.
- Plugin-specific ones live inside the plugin's directory.
- Colorscheme-related integration belongs in `themes/`, near the theme that owns it.

## Verify

```bash
nix fmt            # treefmt: nixfmt + deadnix + statix
nix flake check
```

Then follow the `nix-system-change` skill for the full workflow (staging new files, targeted evals, applying).

If runtime behavior changed, ask before applying, then launch Neovim to check for startup errors.
