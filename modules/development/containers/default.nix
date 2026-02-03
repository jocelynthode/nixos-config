{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.containers.enable = lib.mkEnableOption "containers";

  config = lib.mkIf config.aspects.development.containers.enable {
    virtualisation = {
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune = {
          enable = true;
          flags = [
            "--all"
            "--filter=until=24h"
          ];
        };
      };
      containers = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    aspects.base.persistence = {
      homePaths = [
        {
          directory = ".local/share/containers";
          mode = "0700";
        }
      ];
      systemPaths = [
        "/var/lib/containers"
      ];
    };

    users.users.jocelyn = {
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
  };
}
