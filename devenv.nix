{ pkgs, ... }:
{
  packages = with pkgs; [
    git
    sops
    ssh-to-age
    disko
    nixos-anywhere
  ];

  languages.nix.enable = true;

  git-hooks.hooks = {
    actionlint.enable = true;
    nixfmt.enable = true;
    deadnix = {
      enable = true;
      settings.edit = true;
    };
    statix.enable = true;
  };
}
