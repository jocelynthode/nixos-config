{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.services.jellyfin.enable = lib.mkEnableOption "jellyfin";

  config = lib.mkIf config.aspects.services.jellyfin.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
      }
    ];
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

    users.users.jellyfin = {
      isSystemUser = true;
      extraGroups = ["video"];
    };

    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];

    services.nginx.virtualHosts."stream.tekila.ovh" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
    };
  };
}
