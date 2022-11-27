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
        directory = "/var/lib/bazarr";
        user = "bazarr";
        group = "bazarr";
      }
      {
        directory = "/var/lib/lidarr";
        user = "lidarr";
        group = "lidarr";
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
      lidarr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        # DynamicUser systemd
        enable = true;
        openFirewall = true;
      };
    };

    # Allow access to deluge downloads
    users.users.radarr.extraGroups = ["deluge"];
    users.users.bazarr.extraGroups = ["deluge"];
    users.users.sonarr.extraGroups = ["deluge"];
    users.users.lidarr.extraGroups = ["deluge"];
  };
}
