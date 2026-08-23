# Agent Instructions for `modules/base/neovim`

Augments the root `AGENTS.md`; takes precedence for this subtree.

## Source of truth

Existing modules are the spec. Read 2–3 neighboring plugin modules before writing or changing one.

## Layout

- `default.nix` — root wiring only: nixvim module import, global `opts`, aliases, clipboard, persistence, root-level `extraPlugins`/`extraPackages`/`extraConfigLua`.
- `core/` — global editor behavior (`keymaps.nix`, `autocmds.nix`).
- `plugins/<plugin>/` — one directory per plugin; non-trivial plugins split into `default.nix` (imports) + `settings.nix` + `keymaps.nix` + `autocmds.nix`. New plugin directories must be added to `plugins/default.nix` imports.
- `themes/` — colorschemes; theme-owned plugin integrations live near their theme.
- `pkgs/vimPlugins/` (repo root) — custom plugins exposed as `pkgs.vimPlugins.*`.

## Invariants

1. **Nixvim first**: use `programs.nixvim.*` options over Lua; raw Lua only via `__raw`/`extraConfigLua` where no option exists. Never add standalone `.lua` files.
2. **No custom enable wrappers**: configure `programs.nixvim.plugins.*` directly unless the surrounding pattern already uses a wrapper.
3. Keymap attribute order is `action`, `key`, `mode`, then `options`; leader mappings get `desc`, and `nowait`/`remap` when neighbors set them.
4. Global keymaps go in `core/keymaps.nix`; plugin-specific ones in the plugin's own `keymaps.nix` (same rule for autocommands / `autoGroups`).
5. No standalone documentation files or comments unless asked.

## Verification

```bash
nix fmt            # treefmt: nixfmt + deadnix + statix — no separate statix/deadnix runs needed
nix flake check    # stage new files first — see root AGENTS.md
```

If runtime behavior changed, apply/switch and launch Neovim to check startup.

## Skill

Plugin workflows (adding a plugin, keymap/autocmd placement, custom vimPlugins) are in the `nixvim-plugin` skill.
