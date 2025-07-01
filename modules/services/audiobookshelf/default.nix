{
  config,
  lib,
  ...
}: {
  options.aspects.services.audiobookshelf.enable = lib.mkEnableOption "audiobookshelf";

  config = lib.mkIf config.aspects.services.audiobookshelf.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/audiobookshelf";
        user = "audiobookshelf";
        group = "media";
      }
    ];
    services = {
      audiobookshelf = {
        enable = true;
        group = "media";
      };
    };

    services.nginx.virtualHosts = {
      "audiobooks.tekila.ovh" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.audiobookshelf.port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
