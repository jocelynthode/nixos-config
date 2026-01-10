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
      url = "github:jocelynthode/taxi/remove-tests";
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
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    authentik-nix = {
      url = "github:nix-community/authentik-nix/version/2025.10.3";
    };
  };

  outputs =
    inputs@{
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
      authentik-nix,
      ...
    }:
    let
      sharedSpecialArgs = {
        inherit
          nix-colors
          spicetify-nix
          catppuccin
          nixvim
          ;
      };
      mkPinnedPkgs = system: {
        pkgs-stable = import nixpkgs-stable {
          stdenv.hostPlatform.system = system;
          config.allowUnfree = true;
        };
        pkgs-master = import nixpkgs-master {
          stdenv.hostPlatform.system = system;
          config.allowUnfree = true;
        };
      };
      mkHostSpecialArgs = system: sharedSpecialArgs // mkPinnedPkgs system;
      hardwareProfiles = {
        amdDesktop = [
          hardware.nixosModules.common-cpu-amd
          hardware.nixosModules.common-pc-ssd
          hardware.nixosModules.common-gpu-amd
        ];
        intelLaptop = [
          hardware.nixosModules.common-cpu-intel
          hardware.nixosModules.common-pc-laptop
          hardware.nixosModules.common-pc-laptop-ssd
          hardware.nixosModules.framework-11th-gen-intel
        ];
        intelServer = [
          hardware.nixosModules.common-cpu-intel
          hardware.nixosModules.common-pc-ssd
        ];
      };
    in
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        nur.overlays.default
        taxi.overlays.default
        wofi-ykman.overlays.default
        (import ./overlay { inherit inputs; })
      ];
      hostDefaults = {
        modules = [
          { nix.generateRegistryFromInputs = true; }
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          catppuccin.nixosModules.catppuccin
          nix-index-database.nixosModules.nix-index
          nixvim.nixosModules.nixvim
          disko.nixosModules.disko
          authentik-nix.nixosModules.default
          ./modules
        ];
        specialArgs = sharedSpecialArgs;
      };

      channels = {
        nixpkgs.input = nixpkgs;
        stable.input = nixpkgs-stable;
        master.input = nixpkgs-master;
      };

      outputsBuilder =
        channels:
        let
          pkgs = channels.nixpkgs;
        in
        {
          formatter = pkgs.nixfmt-tree;
          devShells.default = pkgs.mkShell {
            name = "nixos-config";
            packages = with pkgs; [
              git
              nixfmt
              statix
              deadnix
              actionlint
            ];
          };
        };

      hosts = {
        desktek = {
          modules = [
            ./machines/desktek
          ]
          ++ hardwareProfiles.amdDesktop;
          specialArgs = mkHostSpecialArgs "x86_64-linux";
        };
        frametek = {
          modules = [
            ./machines/frametek
          ]
          ++ hardwareProfiles.intelLaptop;
          specialArgs = mkHostSpecialArgs "x86_64-linux";
        };
        servetek = {
          modules = [
            ./machines/servetek
          ]
          ++ hardwareProfiles.intelServer;
          specialArgs = mkHostSpecialArgs "x86_64-linux";
        };
        iso = {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./machines/iso
          ];
        };
      };
    };
}
