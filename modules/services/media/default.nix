{
  config,
  lib,
  ...
}: let
  mkAuthProxy = import ../nginx/auth.nix {inherit lib;};

  mediaServices = [
    {
      name = "sonarr";
      port = 8989;
      useSettings = true;
      createDir = true;
    }
    {
      name = "radarr";
      port = 7878;
      useSettings = true;
      createDir = true;
    }
    {
      name = "bazarr";
      port = 6767;
      useSettings = false;
      createDir = true;
    }
    {
      name = "lidarr";
      port = 8686;
      useSettings = true;
      createDir = true;
    }
    {
      name = "prowlarr";
      port = 9696;
      useSettings = true;
      createDir = false;
    }
  ];

  persistencePaths =
    lib.concatMap
    (service: [
      {
        directory = "/var/lib/${service.name}";
        user = service.name;
        group = "media";
      }
    ])
    (lib.filter (service: service.createDir) mediaServices);

  serviceConfigs = lib.listToAttrs (map (
      service: {
        inherit (service) name;
        value =
          {
            enable = true;
            openFirewall = true;
          }
          // lib.optionalAttrs service.useSettings {
            settings = {
              auth = {
                method = "external";
              };
            };
          }
          // lib.optionalAttrs (service.name != "prowlarr") {
            group = "media";
          };
      }
    )
    mediaServices);

  userGroups = lib.listToAttrs (map (service: {
      inherit (service) name;
      value = {
        extraGroups = ["media"];
      };
    })
    (lib.filter (service: service.createDir) mediaServices));

  tmpFiles = map (service: "d /backups/${service.name} 0750 ${service.name} media -") (lib.filter (service: service.createDir) mediaServices);

  nginxVhosts = lib.listToAttrs (map (
      service: {
        name = "${service.name}.tekila.ovh";
        value = mkAuthProxy {inherit (service) port;};
      }
    )
    mediaServices);
  systemdConfigs = lib.listToAttrs (map (service: {
      inherit (service) name;
      value = {
        serviceConfig = {
          UMask = "0002";
        };
      };
    })
    (lib.filter (service: service.name != "prowlarr") mediaServices));
in {
  options.aspects.services.media.enable = lib.mkEnableOption ''
    Enable all media “arr” services.

    When true, automatically sets up Sonarr, Radarr, Bazarr,
    Lidarr, Prowlarr with persistence paths, firewall
    rules, Deluge group access, and authenticated nginx proxies.
  '';

  config = lib.mkIf config.aspects.services.media.enable {
    aspects.base.persistence.systemPaths = persistencePaths;

    services =
      serviceConfigs
      // {
        nginx.virtualHosts = nginxVhosts;
      };

    systemd = {
      services = systemdConfigs;
      tmpfiles.rules =
        [
          "d /data/media 0775 deluge media -"
          "d /data/media/movies 0775 deluge media -"
          "d /data/media/shows 0775 deluge media -"
          "d /data/media/music 0775 deluge media -"
          "d /data/media/books 0775 deluge media -"
          "d /data/media/audiobooks 0775 deluge media -"
        ]
        ++ tmpFiles;
    };

    users = {
      groups.media = {};
      users = userGroups;
    };
  };
}
