{ pkgs, inputs, lib, ... }:
let
  inherit (lib) mapAttrs' nameValuePair;
  toRegistry = mapAttrs' (n: v: nameValuePair n { flake = v; });
in
{
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };
    # Map flake inputs to system registries
    registry = toRegistry inputs;
  };
}
