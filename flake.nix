{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.05";

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
    discord.url = "github:InternetUnexplorer/discord-overlay";
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
    };
  };

  outputs = inputs@{ self, nixpkgs, stable, home-manager, sops-nix, nur, nix-colors, hardware, impermanence, taxi, discord, utils }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        nur.overlay
        taxi.overlay
        discord.overlay
        (import ./overlay { inherit inputs; })
      ];
      hostDefaults = {
        modules = [
          { nix.generateRegistryFromInputs = true; }
          home-manager.nixosModule
          sops-nix.nixosModules.sops
          impermanence.nixosModules.impermanence
          ./modules
        ];
      };

      channels.nixpkgs.input = nixpkgs;
      channels.stable.input = stable;

      hosts = {
        desktek = {
          modules = [
            ./machines/desktek
            hardware.nixosModules.common-cpu-amd
            hardware.nixosModules.common-pc-ssd
          ];
          specialArgs = { inherit nix-colors; };
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
          specialArgs = { inherit nix-colors; };
        };
        servetek = {
          # channelName = "stable";
          modules = [
            ./machines/servetek
            hardware.nixosModules.common-pc-laptop-hdd
          ];
          specialArgs = { inherit nix-colors; };
        };
        iso = {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./machines/iso
          ];
          specialArgs = { inherit nix-colors; };
        };
      };
      outputsBuilder = channels:
        let pkgs = channels.nixpkgs; in
        {
          devShells =
            let
              ls = builtins.readDir ./shells;
              files = builtins.filter (name: ls.${name} == "regular") (builtins.attrNames ls);
              shellNames = builtins.map (filename: builtins.head (builtins.split "\\." filename)) files;
              nameToValue = name: import (./shells + "/${name}.nix") { inherit pkgs inputs; };
            in
            builtins.listToAttrs (builtins.map (name: { inherit name; value = nameToValue name; }) shellNames);
        };
    };
}
