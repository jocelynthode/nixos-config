{
  config,
  lib,
  ...
}: {
  options.aspects.services.authentik.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = let
    definition = _command: {
      image = "ghcr.io/goauthentik/server:2022.11.1";
      cmd = ["server"];
      dependsOn = [
      ];
      extraOptions = [
        "--network=host"
        "--pull=always"
      ];
      volumes = [
      ];
      environment = {
        AUTHENTIK_REDIS__HOST = "127.0.0.1";
        AUTHENTIK_REDIS__PORT = "6379";
        AUTHENTIK_REDIS__DB = "0";
        AUTHENTIK_POSTGRESQL__HOST = "127.0.0.1";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_COOKIE_DOMAIN = ".tekila.ovh";
      };
      environmentFiles = [
        config.sops.secrets.authentik.path
      ];
    };
  in
    lib.mkIf config.aspects.services.authentik.enable {
      virtualisation.oci-containers.containers = {
        authentik-server = definition "server";
        authentik-worker = definition "worker";
      };

      sops.secrets.authentik = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        restartUnits = [
          "podman-authentik-server.service"
          "podman-authentik-worker.service"
        ];
      };
    };
}
