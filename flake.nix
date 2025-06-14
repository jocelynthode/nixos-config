{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    taxi = {
      url = "github:sephii/taxi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wofi-ykman = {
      url = "github:jocelynthode/wofi-ykman";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
    devenv = {
      url = "github:cachix/devenv/latest";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-master,
    catppuccin,
    home-manager,
    sops-nix,
    nur,
    nix-colors,
    hardware,
    impermanence,
    taxi,
    utils,
    spicetify-nix,
    nix-index-database,
    nixvim,
    wofi-ykman,
    disko,
    ...
  }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        nur.overlays.default
        taxi.overlay
        wofi-ykman.overlays.default
        (import ./overlay {inherit inputs;})
      ];
      hostDefaults = {
        modules = [
          {nix.generateRegistryFromInputs = true;}
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          catppuccin.nixosModules.catppuccin
          nix-index-database.nixosModules.nix-index
          nixvim.nixosModules.nixvim
          disko.nixosModules.disko
          ./modules
        ];
      };

      channels.nixpkgs.input = nixpkgs;

      outputsBuilder = channels:
        with channels.nixpkgs; {
          formatter = alejandra;
        };

      hosts = {
        desktek = {
          modules = [
            ./machines/desktek
            hardware.nixosModules.common-cpu-amd
            hardware.nixosModules.common-pc-ssd
            hardware.nixosModules.common-gpu-amd
          ];
          specialArgs = {
            inherit nix-colors spicetify-nix catppuccin nixvim;
            pkgs-stable = import nixpkgs-stable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
            pkgs-master = import nixpkgs-master {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        };
        frametek = {
          modules = [
            ./machines/frametek
            hardware.nixosModules.common-cpu-intel
            hardware.nixosModules.common-pc-laptop
            hardware.nixosModules.common-pc-laptop-ssd
            hardware.nixosModules.framework-11th-gen-intel
          ];
          specialArgs = {
            inherit nix-colors spicetify-nix catppuccin nixvim;
            pkgs-stable = import nixpkgs-stable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
            pkgs-master = import nixpkgs-master {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        };
        servetek = {
          modules = [
            ./machines/servetek
            hardware.nixosModules.common-cpu-intel
            hardware.nixosModules.common-pc-ssd
          ];
          specialArgs = {
            inherit nix-colors spicetify-nix catppuccin nixvim;
            pkgs-stable = import nixpkgs-stable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
            pkgs-master = import nixpkgs-master {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        };
        iso = {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./machines/iso
          ];
          specialArgs = {inherit nix-colors spicetify-nix catppuccin nixvim;};
        };
      };
    };
}
