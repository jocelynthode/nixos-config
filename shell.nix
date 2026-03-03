{
  system ? builtins.currentSystem,
  sources ? import ./classic/sources.nix { },
  pkgs ? import sources.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  },
}:
pkgs.mkShell {
  packages = with pkgs; [
    deadnix
    nixfmt-tree
    statix
    git
    sops
    ssh-to-age
    disko
    nixos-anywhere
  ];
}
