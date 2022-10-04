# This file (and the global directory) holds config that i use on all hosts
{ pkgs, lib, inputs, hostname, config, ... }:
{
  imports = [
    ./dconf.nix
    ./rage.nix
    ./environment.nix
    ./fish.nix
    ./fonts.nix
    ./gnupg.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./persist.nix
    ./systemd-boot.nix
    ./users.nix
  ];


  networking.hostName = hostname;
  # See https://github.com/NixOS/nixpkgs/commit/15d761a525a025de0680b62e8ab79a9d183f313d 
  systemd.targets.network-online.wantedBy = lib.mkForce [ ]; # Normally ["multi-user.target"]
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ]; # Normally ["network-online.target"]

  nix = {
    # Add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Map registries to channels
    # Very useful when using legacy commands
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  hardware.enableRedistributableFirmware = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    ldns
    xorg.xkill
    gnumake
    gettext
  ];

  system.stateVersion = lib.mkDefault "22.11";
}
