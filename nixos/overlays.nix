{ inputs }:
{
  overlays.default = import ../overlays { inherit inputs; };
}
