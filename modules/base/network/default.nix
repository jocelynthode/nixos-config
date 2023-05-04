{
  pkgs,
  config,
  lib,
  ...
}: {
  aspects.base.persistence.systemPaths = [
    "/etc/NetworkManager/system-connections"
  ];

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
    wireguard.enable = true;
  };

  # See https://github.com/NixOS/nixpkgs/commit/15d761a525a025de0680b62e8ab79a9d183f313d
  systemd.targets.network-online.wantedBy = lib.mkForce []; # Normally ["multi-user.target"]
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Normally ["network-online.target"]
  users.users.jocelyn.extraGroups = lib.mkIf config.networking.networkmanager.enable ["networkmanager"];

  home-manager.users.jocelyn = {pkgs, ...}: {
    home.packages = with pkgs; lib.mkIf config.aspects.graphical.enable [networkmanagerapplet];
  };
}
