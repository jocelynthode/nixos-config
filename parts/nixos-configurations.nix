{
  config,
  inputs,
  lib,
  ...
}:
let
  nixosArgs = import ../flake/nixos-args.nix { inherit inputs; };
  inherit (import ../flake/nixos-shared-modules.nix { inherit inputs; }) sharedModules;
in
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
          specialArgs = lib.mkOption {
            type = lib.types.attrs;
            default = { };
          };
          system = lib.mkOption {
            type = lib.types.str;
          };
        };
      }
    );
    default = { };
  };

  config = {
    configurations.nixos = {
      desktek = {
        system = "x86_64-linux";
        specialArgs = nixosArgs.mkHostSpecialArgs "x86_64-linux";
        module = {
          imports =
            sharedModules
            ++ [
              inputs.hardware.nixosModules.common-cpu-amd
              inputs.hardware.nixosModules.common-pc-ssd
              inputs.hardware.nixosModules.common-gpu-amd
            ]
            ++ [
              config.flake.nixosModules.desktop
              ../machines/desktek
            ];
        };
      };

      frametek = {
        system = "x86_64-linux";
        specialArgs = nixosArgs.mkHostSpecialArgs "x86_64-linux";
        module = {
          imports =
            sharedModules
            ++ [
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-laptop
              inputs.hardware.nixosModules.common-pc-laptop-ssd
              inputs.hardware.nixosModules.framework-11th-gen-intel
            ]
            ++ [
              config.flake.nixosModules.desktop
              ../machines/frametek
            ];
        };
      };

      servetek = {
        system = "x86_64-linux";
        specialArgs = nixosArgs.mkHostSpecialArgs "x86_64-linux";
        module = {
          imports =
            sharedModules
            ++ [
              inputs.hardware.nixosModules.common-cpu-intel
              inputs.hardware.nixosModules.common-pc-ssd
            ]
            ++ [
              config.flake.nixosModules.server
              ../machines/servetek
            ];
        };
      };

      iso = {
        system = "x86_64-linux";
        specialArgs = nixosArgs.sharedSpecialArgs;
        module = {
          imports = sharedModules ++ [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            config.flake.nixosModules.common
            ../machines/iso
          ];
        };
      };
    };

    flake.nixosConfigurations = lib.mapAttrs (
      _name: nixos:
      inputs.nixpkgs.lib.nixosSystem {
        inherit (nixos) specialArgs system;
        modules = [
          nixos.module
        ];
      }
    ) config.configurations.nixos;
  };
}
