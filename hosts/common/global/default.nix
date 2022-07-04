# This file (and the global directory) holds config that i use on all hosts
{ lib, inputs, hostname, ... }:
{
  imports = [
    ./environment.nix
    ./fish.nix
    ./fonts.nix
    ./locale.nix
    ./nix.nix
    ./persist.nix
    ./systemd-boot.nix
    ./users.nix
  ];

  networking.hostName = hostname;
  # See https://github.com/NixOS/nixpkgs/commit/15d761a525a025de0680b62e8ab79a9d183f313d 
  systemd.targets.network-online.wantedBy = lib.mkForce [ ]; # Normally ["multi-user.target"]
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ]; # Normally ["network-online.target"]

  # Add each flake input as a registry
  nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

  hardware.enableRedistributableFirmware = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  system.stateVersion = lib.mkDefault "22.11";
}
