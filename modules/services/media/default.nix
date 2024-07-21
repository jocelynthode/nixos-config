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
        directory = "/var/backup/sonarr";
        user = "sonarr";
        group = "sonarr";
      }
      {
        directory = "/var/lib/radarr";
        user = "radarr";
        group = "radarr";
      }
      {
        directory = "/var/backup/radarr";
        user = "radarr";
        group = "radarr";
      }
      {
        directory = "/var/lib/bazarr";
        user = "bazarr";
        group = "bazarr";
      }
      {
        directory = "/var/backup/bazarr";
        user = "bazarr";
        group = "bazarr";
      }
      {
        directory = "/var/lib/lidarr";
        user = "lidarr";
        group = "lidarr";
      }
      {
        directory = "/var/backup/lidarr";
        user = "lidarr";
        group = "lidarr";
      }
      {
        directory = "/var/lib/readarr";
        user = "readarr";
        group = "readarr";
      }
      {
        directory = "/var/backup/readarr";
        user = "readarr";
        group = "readarr";
      }
      {
        directory = "/var/backup/prowlarr";
        user = "prowlarr";
        group = "prowlarr";
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
      readarr = {
        enable = true;
        openFirewall = true;
      };
    };

    # Allow access to deluge downloads
    users.users = {
      radarr.extraGroups = ["deluge"];
      bazarr.extraGroups = ["deluge"];
      sonarr.extraGroups = ["deluge"];
      lidarr.extraGroups = ["deluge"];
      readarr.extraGroups = ["deluge"];
    };
  };
}
