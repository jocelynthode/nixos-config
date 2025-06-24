{
  config,
  lib,
  ...
}: {
  options.aspects.services.recyclarr.enable = lib.mkEnableOption "recyclarr";

  config = lib.mkIf config.aspects.services.recyclarr.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/recyclarr";
        user = "recyclarr";
        group = "recyclarr";
      }
    ];

    services.recyclarr = {
      enable = true;
      configuration = {
        radarr = {
          radarr_main = {
            api_key = {
              _secret = config.sops.secrets.radarrApiKey.path;
            };
            base_url = "http://localhost:${toString config.services.radarr.settings.server.port}";
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;
            quality_definition = {
              type = "movies";
              preferred_ratio = 0.7;
            };
            include = [
              {
                template = "radarr-quality-profile-anime";
              }
              {
                template = "radarr-custom-formats-anime";
              }
              {
                template = "radarr-quality-profile-remux-web-2160p";
              }
              {
                template = "radarr-custom-formats-remux-web-2160p";
              }
              {
                template = "radarr-quality-profile-uhd-remux-web-french-multi-vo";
              }
              {
                template = "radarr-custom-formats-uhd-remux-web-french-multi-vo";
              }
              {
                template = "radarr-quality-profile-hd-bluray-web-french-multi-vo";
              }
              {
                template = "radarr-custom-formats-hd-bluray-web-french-multi-vo";
              }
              {
                template = "radarr-quality-profile-remux-web-1080p";
              }
              {
                template = "radarr-custom-formats-remux-web-1080p";
              }
            ];
            media_naming = {
              folder = "default";
              movie = {
                rename = true;
                standard = "default";
              };
            };
          };
        };
        sonarr = {
          sonarr_main = {
            api_key = {
              _secret = config.sops.secrets.sonarrApiKey.path;
            };
            base_url = "http://localhost:${toString config.services.sonarr.settings.server.port}";
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;
            quality_definition = {
              type = "series";
              preferred_ratio = 0.7;
            };
            include = [
              {
                template = "sonarr-v4-quality-profile-anime";
              }
              {
                template = "sonarr-v4-custom-formats-anime";
              }
              {
                template = "sonarr-v4-quality-profile-web-2160p-alternative";
              }
              {
                template = "sonarr-v4-custom-formats-web-2160p";
              }
              {
                template = "sonarr-v4-quality-profile-bluray-web-2160p-french-multi-vo";
              }
              {
                template = "sonarr-v4-custom-formats-bluray-web-2160p-french-multi-vo";
              }
              {
                template = "sonarr-v4-quality-profile-web-1080p";
              }
              {
                template = "sonarr-v4-custom-formats-web-1080p";
              }
              {
                template = "sonarr-v4-quality-profile-bluray-web-1080p-french-multi-vo";
              }
              {
                template = "sonarr-v4-custom-formats-bluray-web-1080p-french-multi-vo";
              }
            ];
            media_naming = {
              series = "default";
              season = "default";
              episodes = {
                rename = true;
                standard = "default";
                daily = "default";
                anime = "default";
              };
            };
          };
        };
      };
    };

    sops.secrets = {
      radarrApiKey = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        owner = "recyclarr";
      };
      sonarrApiKey = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        owner = "recyclarr";
      };
    };
  };
}
