{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs:
    let
      my-lib = import ./lib { inherit inputs; };
      inherit (builtins) attrValues;
      inherit (inputs.nixpkgs.lib) genAttrs systems;
      inherit (my-lib) mkSystem importAttrset;
      forAllSystems = genAttrs systems.flakeExposed;
      system = "x86_64-linux";                             	    # System architecture
    in
    rec {
      overlays = {
        default = import ./overlay { inherit inputs; };
        nur = inputs.nur.overlay;
      };

      packages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = attrValues overlays;
          config.allowUnfree = true;
        }
      );

      homeManagerModules = importAttrset ./modules/home-manager;

      nixosConfigurations = {
        desktek = mkSystem {
          inherit packages system;
          hostname = "desktek";
        };
      };
    };
}
