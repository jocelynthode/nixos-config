{ inputs, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (inputs) self nixpkgs;
  inherit (nixpkgs.lib) nixosSystem;

  mylib = {
    importAttrset = path: mapAttrs (_: import) (import path);

    mkSystem =
      { hostname
      , colorscheme
      , system
      , packages
      }:
      nixosSystem {
        inherit system;
        pkgs = packages.${system};
        specialArgs = {
          inherit mylib inputs system hostname colorscheme;
        };
        modules = [
          ../hosts/${hostname}
        ];
      };
  };
in
mylib
