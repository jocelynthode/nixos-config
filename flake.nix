{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
    taxi.url = "github:sephii/taxi";
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv/latest";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    hyprland,
    home-manager,
    sops-nix,
    nur,
    nix-colors,
    hardware,
    impermanence,
    taxi,
    utils,
    spicetify-nix,
    ...
  }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        nur.overlay
        taxi.overlay
        (import ./overlay {inherit inputs;})
      ];
      hostDefaults = {
        modules = [
          {nix.generateRegistryFromInputs = true;}
          sops-nix.nixosModules.sops
          home-manager.nixosModule
          impermanence.nixosModules.impermanence
          hyprland.nixosModules.default
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
          specialArgs = {inherit nix-colors spicetify-nix;};
        };
        frametek = {
          modules = [
            ./machines/frametek
            hardware.nixosModules.common-cpu-intel
            hardware.nixosModules.common-gpu-intel
            hardware.nixosModules.common-pc-laptop
            hardware.nixosModules.common-pc-laptop-ssd
            hardware.nixosModules.framework
          ];
          specialArgs = {inherit nix-colors spicetify-nix;};
        };
        servetek = {
          modules = [
            ./machines/servetek
            hardware.nixosModules.common-pc-laptop-ssd
          ];
          specialArgs = {inherit nix-colors spicetify-nix;};
        };
        iso = {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./machines/iso
          ];
          specialArgs = {inherit nix-colors spicetify-nix;};
        };
      };
    };
}
