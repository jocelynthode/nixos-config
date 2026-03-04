{ inputs, ... }:
{
  config.flake.lib.autowire = import ../lib/autowire.nix { inherit (inputs.nixpkgs) lib; };
  config.flake.lib.nixosArgs = import ../lib/nixos-args.nix { inherit inputs; };
}
