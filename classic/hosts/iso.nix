_:
let
  sources = import ../sources.nix { };
  inputs = import ../inputs.nix { inherit sources; };
  nixosArgs = import ../nixos-args.nix { inherit inputs; };
  hostModules = import ../host-modules.nix { inherit inputs; };
in
{
  _module.args = nixosArgs.sharedSpecialArgs;
  imports = hostModules.iso;
}
