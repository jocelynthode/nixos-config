{
  config,
  lib,
  ...
}:
{
  options.aspects.services.authentik.enable = lib.mkEnableOption "authentik";

  config =
    let
      mkAuthProxy = import ../nginx/auth.nix { inherit lib; };
    in
    lib.mkIf config.aspects.services.authentik.enable {
      services.nginx.virtualHosts."auth.tekila.ovh" = mkAuthProxy {
        port = 9000;
        protect = false;
      };

      # TODO nixify these steps
      # On first run we need to set a password for the authentik database in postgresql
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
