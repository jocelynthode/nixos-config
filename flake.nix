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

    hardware.url = "github:nixos/nixos-hardware";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      url = "github:gytis-ivaskevicius/flake-utils-plus/v1.5.1";
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
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    authentik-nix = {
      url = "github:nix-community/authentik-nix/version/2025.12.1";
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
      hardware,
      impermanence,
      taxi,
      utils,
      spicetify-nix,
      nix-index-database,
      nixvim,
      wofi-ykman,
      niri,
      stylix,
      disko,
      authentik-nix,
      noctalia,
      ...
    }:
    let
      sharedSpecialArgs = {
        inherit
          authentik-nix
          spicetify-nix
          catppuccin
          impermanence
          nix-index-database
          nixvim
          niri
          noctalia
          stylix
          ;
        hostRole = "desktop";
      };
      mkHostSpecialArgs =
        system:
        sharedSpecialArgs
        // {
          pkgs-stable = self.pkgs.${system}.stable;
          pkgs-master = self.pkgs.${system}.master;
        };
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

      supportedSystems = [
        "x86_64-linux"
      ];

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        nur.overlays.default
        taxi.overlays.default
        wofi-ykman.overlays.default
        # niri.overlays.niri
        (import ./overlay { inherit inputs; })
      ];
      hostDefaults = {
        modules = [
          { nix.generateRegistryFromInputs = true; }
          catppuccin.nixosModules.catppuccin
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
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
        # experiment with disabling some import to speedup build
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
          specialArgs = mkHostSpecialArgs "x86_64-linux" // {
            hostRole = "server";
          };
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
