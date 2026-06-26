default:
    @just --list

push host:
    nix build -L --no-link '.#nixosConfigurations.{{ host }}.config.system.build.toplevel'
    nix eval --json '.#nixosConfigurations.{{ host }}.config.system.build.toplevel.outPath' \
      | sed 's/"\(.*\)"/\1/' \
      | cachix push tekila
