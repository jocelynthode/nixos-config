---
name: nix-system-change
description: "Verify and apply a configuration change in this NixOS flake repository. Use when the user asks to apply or deploy the configuration, after finishing any edit (fmt, git staging, flake check, eval), or when a build/eval fails confusingly."
---

# Verifying and applying a system change

## Verification workflow

1. `git status --short` — review what changed; never overwrite unrelated user work.
2. **Stage new files**: the flake source filter only sees Git-tracked files. Untracked files cause confusing "option does not exist" / "infinite recursion" errors. `git add` them (staging for validation is fine; do not commit unless asked).
3. `nix fmt` — formatting authority; do not hand-format.
4. `nix flake check` — must pass (CI gate).
5. For quick targeted checks without a full build:
   ```bash
   nix eval .#nixosConfigurations.<host>.config.<option-path>
   ```
   Hosts: `desktek`, `frametek`, `iso`, `servetek`.

## Reporting results

Distinguish clearly between:

- files already tracked,
- newly created files that had to be staged for evaluation,
- actual validation failures.

## Applying

```bash
nh os switch -a '.'
```

Avoid `nixos-rebuild switch --flake` unless `nh` cannot do it. Ask before switching on a machine the user didn't reference.

## Common gotchas

- "infinite recursion" or missing-option errors right after moving/renaming modules: check relative `sopsFile` paths and nested import-tree wiring.
- Sandbox (`nono`) denials (`EPERM`, landlock) during builds are sandbox boundaries, not flake errors.
