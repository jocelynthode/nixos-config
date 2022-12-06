{pkgs, ...}: {
  packages = with pkgs; [
    git
    sops
    ssh-to-age
  ];

  languages.nix.enable = true;

  pre-commit.hooks = {
    actionlint.enable = true;
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };

  pre-commit.settings.deadnix.edit = true;
}
