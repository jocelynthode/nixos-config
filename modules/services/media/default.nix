{
  config,
  lib,
  ...
}: {
  options.aspects.services.media.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.media.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/sonarr";
        user = "sonarr";
        group = "sonarr";
      }
      {
        directory = "/var/lib/radarr";
        user = "radarr";
        group = "radarr";
      }
      {
        directory = "/var/lib/jackett";
        user = "jackett";
        group = "jackett";
      }
      {
        directory = "/var/lib/bazarr";
        user = "bazarr";
        group = "bazarr";
      }
    ];

    services = {
      radarr = {
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
      bazarr = {
        enable = true;
        openFirewall = true;
      };
      jackett = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
