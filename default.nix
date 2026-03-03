_:
let
  sources = import ./classic/sources.nix { };
  inputs = import ./classic/inputs.nix { inherit sources; };
in
import ./classic/nixos-configurations.nix { inherit inputs; }
