{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    taxi.url = "github:sephii/taxi";
    discord.url = "github:InternetUnexplorer/discord-overlay";
  };

  outputs = inputs:
    let
      my-lib = import ./lib { inherit inputs; };
      inherit (builtins) attrValues;
      inherit (inputs.nixpkgs.lib) genAttrs systems;
      inherit (my-lib) mkSystem importAttrset;
      forDefaultSystems = genAttrs inputs.flake-utils.lib.defaultSystems;
      system = inputs.flake-utils.lib.system.x86_64-linux;
    in
    rec {
      overlays = {
        default = import ./overlay { inherit inputs system; };
        nur = inputs.nur.overlay;
        taxi-cli = inputs.taxi.overlay;
        discord = inputs.discord.overlay;
      };

      legacyPackages = forDefaultSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = attrValues overlays;
          config.allowUnfree = true;
        }
      );

      devShells = forDefaultSystems (system: {
        default = import ./shell.nix { pkgs = legacyPackages.${system}; };
      });

      nixosConfigurations = {
        iso = mkSystem {
          inherit system;
          packages = legacyPackages;
          hostname = "iso";
          colorscheme = "gruvbox-dark-hard";
        };
        desktek = mkSystem {
          inherit system;
          packages = legacyPackages;
          hostname = "desktek";
          colorscheme = "gruvbox-material-dark-hard";
          wallpaper = "palms-tropics";
        };
        frametek = mkSystem {
          inherit system;
          packages = legacyPackages;
          hostname = "frametek";
          colorscheme = "gruvbox-material-dark-hard";
          wallpaper = "palms-tropics";
        };
        servetek = mkSystem {
          inherit system;
          packages = legacyPackages;
          hostname = "servetek";
          colorscheme = "gruvbox-material-dark-hard";
          wallpaper = "palms-tropics";
        };
      };
    };
}
