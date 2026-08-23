---
name: nix-options
description: Verify NixOS, Home Manager, or Nixvim option names against the exact versions pinned by this repository before using them. Use whenever writing or changing Nix module options (services.*, programs.*, plugins.* etc.) instead of guessing or relying on memory of online docs.
---

# Nix option discovery

Do not guess Nix option names. Query the version-matched option database first:

```bash
<skill-dir>/nix-option-search <nixos|home-manager|nixvim> "<query>"
```

Resolve `<skill-dir>` relative to this SKILL.md's own location (e.g. `.agents/skills/nix-options/` from the repo root, or `~/.agents/skills/nix-options/` when installed globally).

Examples:

```bash
.agents/skills/nix-options/nix-option-search home-manager "programs.git.enable"   # exact
.agents/skills/nix-options/nix-option-search nixos "pipewire bluetooth"           # fuzzy
.agents/skills/nix-options/nix-option-search nixvim "lsp virtual text"
```

## Workflow

1. Determine which layer owns the option: NixOS (`services.*`, `boot.*`, `networking.*`, …), Home Manager (`programs.git.*`, `home.*` in a `home-manager.users.*` context), or Nixvim (`programs.nixvim.*` / `plugins.*`).
2. Exact-lookup the candidate name; if unsure of the name, fuzzy-search by topic words.
3. Check the reported **Type** and **Default** before using it; check **Declared by** to find the defining module.
4. After confirming existence, look at how this repository uses the option (grep `modules/`) and follow that pattern.
5. If no option is found, say so — never invent one.

## Version awareness

Every result header shows `Source:` and `Version:` (the locked revision from `flake.lock`). The databases are derived from exactly what this repository evaluates:

- `nixos`: evaluated host config (`system.build.manual.optionsJSON`)
- `home-manager`: HM's JSON export (`manual.json.enable`, enabled in `modules/development/ai/pi/default.nix`)
- `nixvim`: `options-json` package built from the nixvim rev in `flake.lock`

If you suspect drift (e.g. after `nix flake update`), re-run the command — nixvim results are cached per revision under `~/.cache/nix-option-search/`; delete the cache entry if needed.

## Fallback order

1. This tool (local, version-pinned)
2. Repository source and existing examples
3. Online docs only as last resort — and warn about version mismatch when doing so

Options: `--json` for machine-readable output, `--limit N` (default 12), `--host NAME` if the default host (`desktek`) is not appropriate.
