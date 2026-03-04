{ inputs, ... }:
{
  config.flake.overlays.default = import ../overlay { inherit inputs; };
}
