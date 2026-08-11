{
  config,
  lib,
  ...
}:
{
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
            quality_definition = {
              type = "movies";
              preferred_ratio = 0.7;
            };
            quality_profiles = [
              # Existing: Remux-1080p - Anime
              {
                name = "Remux-1080p - Anime";
                trash_id = "722b624f9af1e492284c4bc842153a38";
              }
              # Existing: Remux + WEB 1080p
              {
                name = "Remux + WEB 1080p";
                trash_id = "9ca12ea80aa55ef916e3751f4b874151";
              }
              # Existing: Remux + WEB 2160p
              {
                name = "Remux + WEB 2160p";
                trash_id = "fd161a61e3ab826d3a22d53f935696dd";
              }
              # Existing: FR-MULTi-VO-HD
              {
                name = "FR-MULTi-VO-HD";
                trash_id = "2572ce3ea4eef1c19d59e0e20ed1cea7";
              }
              # Existing: FR-MULTi-VO-UHD
              {
                name = "FR-MULTi-VO-UHD";
                trash_id = "92ead7022d13a7858d54e328e6a2f8f9";
              }
              # Existing: FR-REMUX-MULTi-VO-HD
              {
                name = "FR-REMUX-MULTi-VO-HD";
                trash_id = "c6460a102b312200c095a2d0982e0461";
              }
              # Existing: FR-REMUX-MULTi-VO-UHD
              {
                name = "FR-REMUX-MULTi-VO-UHD";
                trash_id = "1fef28c8c919f31cd86283b1baf527d4";
              }
            ];

            media_naming = {
              folder = "jellyfin-imdb";
              movie = {
                rename = true;
                standard = "jellyfin-imdb";
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
            quality_definition = {
              type = "series";
              preferred_ratio = 0.7;
            };
            quality_profiles = [
              # Existing: Remux-1080p - Anime
              {
                name = "Remux-1080p - Anime";
                trash_id = "20e0fc959f1f1704bed501f23bdae76f";
              }
              # Existing: WEB-1080p
              {
                name = "WEB-1080p";
                trash_id = "72dae194fc92bf828f32cde7744e51a1";
              }
              # Existing: WEB-2160p
              {
                name = "WEB-2160p";
                trash_id = "dfa5eaae7894077ad6449169b6eb03e0";
              }
              # Existing: FR-MULTi-VO-WEB-1080p
              {
                name = "FR-MULTi-VO-WEB-1080p";
                trash_id = "4c48f506c1116a3a57ae33f12346bd15";
              }
              # Existing: FR-MULTi-VO-WEB-2160p
              {
                name = "FR-MULTi-VO-WEB-2160p";
                trash_id = "6fa7364373e8f06206871d9c20a4fb3e";
              }
            ];
            media_naming = {
              series = "jellyfin-tvdb";
              season = "default";
              episodes = {
                rename = true;
                standard = "default";
                daily = "default";
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
