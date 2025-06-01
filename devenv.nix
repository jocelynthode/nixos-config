{pkgs, ...}: {
  packages = with pkgs; [
    git
    sops
    ssh-to-age
  ];

  languages.nix.enable = true;

  git-hooks.hooks = {
    actionlint.enable = true;
    alejandra.enable = true;
    deadnix = {
      enable = true;
      settings.edit = true;
    };
    statix.enable = true;
  };
}
