{ pkgs, inputs, lib, ... }:
let
  inherit (lib) mapAttrs' nameValuePair;
  toRegistry = mapAttrs' (n: v: nameValuePair n { flake = v; });
in
{
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };
    # Map flake inputs to system registries
    registry = toRegistry inputs;
  };
}
