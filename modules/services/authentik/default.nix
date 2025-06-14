{
  config,
  lib,
  ...
}: {
  options.aspects.services.authentik.enable = lib.mkEnableOption "authentik";

  config = let
    mkAuthProxy = import ../nginx/auth.nix {inherit lib;};
  in
    lib.mkIf config.aspects.services.authentik.enable {
      aspects.base.persistence.systemPaths = [
        {
          directory = "/var/lib/authentik";
          user = "authentik";
          group = "authentik";
        }
      ];

      services.nginx.virtualHosts."auth.tekila.ovh" = mkAuthProxy {
        port = 9000;
        protect = false;
      };

      # TODO Tries to go to authentik 2025.04
      services.authentik = {
        enable = true;
        environmentFile = config.sops.secrets.authentik.path;
        createDatabase = true;
        settings = {
          disable_startup_analytics = true;
          avatars = "initials";
        };
      };

      sops.secrets.authentik = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        owner = "authentik";
        group = "authentik";
      };
    };
}
