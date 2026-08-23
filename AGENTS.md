# Agent Instructions

## Source of truth

- This file documents conventions and invariants, not the complete implementation. Repository code is authoritative when docs and code disagree.
- Inspect existing implementations before making architectural decisions. If a durable convention changes, update this file in the same change.

## Repository map

- `flake.nix` — entry point. `parts/` — flake-parts wiring: `nixos-configurations.nix` (hosts), `nixos-modules.nix` (module aggregation), `overlays.nix`.
- `modules/<category>/<feature>/default.nix` — one module per feature, categorized: `base/`, `development/` (incl. `ai/` for AI tooling), `programs/`, `services/`, `games/`, `graphical/`, `work/`. Category `default.nix` files set `mkDefault` enables.
- `machines/<hostname>/default.nix` — host config; enables aspects and sets host-specific options. Hosts: `desktek`, `frametek`, `iso`, `servetek`.
- `pkgs/` — custom packages; exposed via `overlay/`.
- `secrets/` — sops-encrypted secrets, per-host overrides.
- Nested `AGENTS.md` files override this one for their subtree.

## Aspects

Features are toggled through the `options.aspects.<category>.<feature>.enable` abstraction. To enable a feature on a machine, set `aspects.<category>.<feature>.enable` in `machines/<hostname>/default.nix`. Never scatter raw `services.*.enable` options in machine files. Before creating a new aspect, search `modules/` for an existing one.

## Patterns

- Before introducing a new pattern or abstraction, find and follow an existing implementation of the same category. Do not invent architecture.
- Module files use the import-tree pattern (`import-tree.match "^/[^/]+/default\.nix$"`), which auto-imports **only one directory level**. Deeper nesting requires explicit `imports` in the parent `default.nix` (see `modules/development/ai/default.nix`).
- Do not guess Nix option names: verify options exist for this repository's pinned versions via the `nix-options` skill before using them.

## Impermanence

Root is ephemeral. Persist state from the module that needs it via `aspects.base.persistence.homePaths` / `systemPaths` — do not edit `modules/base/persistence/default.nix` casually.

## Secrets

- Never commit plaintext secrets. Use `sops-nix` (`secrets/`).
- Declare secrets in the module that consumes them (`sops.secrets.<name> = { sopsFile = <relative path>; owner = ...; }`). Mind relative `sopsFile` paths when moving modules between directories.
- Reference secrets as `config.sops.secrets.<name>.path`.

## Sandbox (nono)

Agents may run inside the nono sandbox. If a command fails with `Permission denied` / `EPERM` / `landlock`, it is a sandbox boundary, not a Nix problem. Do not edit `~/.config/nono/profiles` (registry-managed) from inside the sandbox; write drafts to `~/.config/nono/profile-drafts/` and have the user run `nono profile promote <name>`.

## Verification

```bash
nix fmt            # treefmt: nixfmt + deadnix + statix (+ prettier/shfmt)
nix flake check    # must pass; CI uses this
```

**`nix flake check` only sees Git-tracked files.** New files are invisible until staged: check `git status --short`, `git add` new files, then re-run. Staging for validation is fine; never commit unless explicitly asked.

## Applying configuration

Use `nh os switch -a '.'`. Avoid `nixos-rebuild` unless `nh` cannot do the job.

## Scope and safety

- Make small, focused changes. No unrelated refactors.
- Do not overwrite or revert unrelated user changes — check `git status` first.
- Do not create commits unless explicitly requested.

## Commits

If asked to commit, use Conventional Commits: `<type>(<scope>): <subject>` with types `feat`, `fix`, `refactor`, `style`, `docs`, `chore`.

## Skills

Procedural how-tos live in `.agents/skills/` and are loaded only when relevant:

- `nix-module` — adding a program or service module
- `nix-package` — adding a custom package
- `nix-system-change` — verifying and applying a configuration change
- `nix-options` — searching pinned NixOS/Home Manager/Nixvim option databases
