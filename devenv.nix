{ pkgs, ... }:

{
  packages = with pkgs; [
    git
    sops
    ssh-to-age
  ];

  languages.nix.enable = true;

  pre-commit.hooks = {
    shellcheck.enable = true;
    deadnix.enable = true;
  };
}
