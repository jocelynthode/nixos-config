{ inputs, pkgs }:
{
  lib = {
    autowire = import ../lib/autowire.nix { lib = pkgs.lib; };
    nixosArgs = import ../lib/nixos-args.nix { inherit inputs; };
  };
}
