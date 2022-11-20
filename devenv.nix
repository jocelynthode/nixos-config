{ pkgs, ... }:

{
  packages = with pkgs; [
    git
    sops
    ssh-to-age
  ];

  languages.nix.enable = true;

  pre-commit.hooks = {
    deadnix.enable = true;
    statix.enable = true;
    actionlint.enable = true;
  };

  pre-commit.settings.deadnix.edit = true;
}
