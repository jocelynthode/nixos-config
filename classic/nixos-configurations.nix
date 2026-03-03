{ inputs }:
let
  nixosArgs = import ./nixos-args.nix { inherit inputs; };
  hostModules = import ./host-modules.nix { inherit inputs; };

  mkHost =
    {
      system,
      specialArgs,
      modules,
    }:
    import (inputs.nixpkgs + "/nixos/lib/eval-config.nix") {
      inherit system specialArgs modules;
    };
in
{
  nixosConfigurations = {
    desktek = mkHost {
      system = "x86_64-linux";
      specialArgs = nixosArgs.mkHostSpecialArgs "x86_64-linux";
      modules = hostModules.desktek;
    };

    frametek = mkHost {
      system = "x86_64-linux";
      specialArgs = nixosArgs.mkHostSpecialArgs "x86_64-linux";
      modules = hostModules.frametek;
    };

    servetek = mkHost {
      system = "x86_64-linux";
      specialArgs = nixosArgs.mkHostSpecialArgs "x86_64-linux";
      modules = hostModules.servetek;
    };

    iso = mkHost {
      system = "x86_64-linux";
      specialArgs = nixosArgs.sharedSpecialArgs;
      modules = hostModules.iso;
    };
  };
}
