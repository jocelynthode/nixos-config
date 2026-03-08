{
  sources ? import ./npins,
  system ? builtins.currentSystem,
}:
let
  flakeCompat =
    src:
    # Use our pinned flake-compat for flake-only inputs instead of the repo flake-compat input.
    (import (sources.flake-compat + "/default.nix") { inherit src; }).defaultNix;

  inputs = sources // {
    import-tree = import sources.import-tree;

    niri = flakeCompat sources.niri;
    authentik-nix = flakeCompat sources.authentik-nix;
    nixvim = flakeCompat sources.nixvim;
    noctalia = flakeCompat sources.noctalia;
    spicetify-nix = flakeCompat sources.spicetify-nix;
    stylix = flakeCompat sources.stylix;
    taxi = flakeCompat sources.taxi;
    wofi-ykman = flakeCompat sources.wofi-ykman;
  };

  pkgs = import inputs.nixpkgs { inherit system; };
  partsLib = import ./nixos/lib.nix { inherit inputs pkgs; };
  overlays = (import ./nixos/overlays.nix { inherit inputs; }).overlays;
  nixosModules = (import ./nixos/modules.nix { inherit inputs; }).nixosModules;
  nixosConfigurations =
    (import ./nixos/configurations.nix {
      inherit inputs overlays nixosModules;
      lib = partsLib.lib;
    }).nixosConfigurations;

  treefmt-nix = import inputs.treefmt-nix;
  git-hooks = import inputs.git-hooks-nix;
  devShells = {
    default = import ./shell.nix {
      inherit
        inputs
        pkgs
        treefmt-nix
        git-hooks
        ;
    };
  };
in
{
  inherit
    inputs
    overlays
    nixosModules
    nixosConfigurations
    devShells
    ;
  lib = partsLib.lib;
}
