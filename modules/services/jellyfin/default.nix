{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.services.jellyfin.enable = lib.mkEnableOption "jellyfin";

  config = lib.mkIf config.aspects.services.jellyfin.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "media";
      }
    ];
    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
        group = "media";
      };
      seerr = {
        enable = true;
        openFirewall = false;
        configDir = "/var/lib/seerr";
      };
    };

    # Keep StateDirectory aligned with services.seerr.configDir parent while
    # system.stateVersion is still < 26.05.
    systemd.services.seerr.serviceConfig.StateDirectory = lib.mkForce "seerr";

    systemd.tmpfiles.rules = [
      "d /scratch/jellyfin 0755 jellyfin media -"
    ];

    systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

    users.users.jellyfin = {
      isSystemUser = true;
      extraGroups = [
        "video"
        "media"
      ];
    };

    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];

    services.nginx.virtualHosts = {
      "request.tekila.ovh" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.seerr.port}";
            proxyWebsockets = true;
          };
        };
      };
      "stream.tekila.ovh" = {
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
  };
}
