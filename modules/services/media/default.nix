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
    }
    {
      name = "radarr";
      port = 7878;
    }
    {
      name = "bazarr";
      port = 6767;
    }
    {
      name = "lidarr";
      port = 8686;
    }
    {
      name = "prowlarr";
      port = 9696;
    }
    {
      name = "readarr";
      port = 8787;
    }
  ];

  persistencePaths =
    lib.concatMap (
      service: [
        {
          directory = "/var/lib/${service.name}";
          user = service.name;
          group = service.name;
        }
        {
          directory = "/var/backup/${service.name}";
          user = service.name;
          group = service.name;
        }
      ]
    )
    mediaServices;

  serviceConfigs = lib.listToAttrs (map (
      service: {
        inherit (service) name;
        value = {
          enable = true;
          openFirewall = true;
        };
      }
    )
    mediaServices);

  userGroups = lib.listToAttrs (map (
      service: {
        inherit (service) name;
        value = {extraGroups = ["deluge"];};
      }
    )
    mediaServices);

  nginxVhosts = lib.listToAttrs (map (
      service: {
        name = "${service.name}.tekila.ovh";
        value = mkAuthProxy {inherit (service) port;};
      }
    )
    mediaServices);
in {
  options.aspects.services.media.enable = lib.mkEnableOption ''
    Enable all media “arr” services.

    When true, automatically sets up Sonarr, Radarr, Bazarr,
    Lidarr, Prowlarr and Readarr with persistence paths, firewall
    rules, Deluge group access, and authenticated nginx proxies.
  '';

  config = lib.mkIf config.aspects.services.media.enable {
    aspects.base.persistence.systemPaths = persistencePaths;

    services =
      serviceConfigs
      // {
        nginx.virtualHosts = nginxVhosts;
      };

    users.users = userGroups;
  };
}
