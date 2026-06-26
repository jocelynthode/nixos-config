{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.containers.enable = lib.mkEnableOption "containers";

  config = lib.mkIf config.aspects.development.containers.enable {

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

    virtualisation = {
      oci-containers.backend = "docker";

      docker = {
        enable = true;
        autoPrune = {
          enable = true;
          flags = [
            "--all"
            "--filter=until=24h"
          ];
        };
      };
    };
    users.users.jocelyn = {
      extraGroups = [
        "docker"
      ];
    };
  };
}
