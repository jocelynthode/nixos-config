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
    hosts = {
      "127.0.0.1" = [
        config.networking.hostName
        "localhost"
      ];
    };
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
    wireguard.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };

  users.users.jocelyn.extraGroups = lib.mkIf config.networking.networkmanager.enable ["networkmanager"];

  home-manager.users.jocelyn = {pkgs, ...}: {
    home.packages = with pkgs; lib.mkIf config.aspects.graphical.enable [networkmanagerapplet];
  };
}
