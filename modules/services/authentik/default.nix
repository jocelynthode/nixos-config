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
    definition = {
      cmd,
      dependsOn ? [],
      volumes,
    }: {
      inherit cmd volumes dependsOn;
      image = "ghcr.io/goauthentik/server:2022.11.1";
      # user = "100000:100000"; # authentik:authentik
      extraOptions = [
        "--network=host"
        "--pull=always"
      ];
      environment = {
        AUTHENTIK_REDIS__HOST = "127.0.0.1";
        AUTHENTIK_REDIS__PORT = "6379";
        AUTHENTIK_REDIS__DB = "0";
        AUTHENTIK_POSTGRESQL__HOST = "127.0.0.1";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        # AUTHENTIK_COOKIE_DOMAIN = ".tekila.ovh";
      };
      environmentFiles = [
        config.sops.secrets.authentik.path
      ];
    };
  in
    lib.mkIf config.aspects.services.authentik.enable {
      aspects.base.persistence.systemPaths = [
        {
          directory = "/var/lib/authentik";
          user = "1000"; # basic authentik user
          group = "1000";
        }
      ];

      # TODO nixify these steps
      # On first run we need to set a password for the authentik database in postgresql
      # The various volumes must also be created and be owned by authentik:root
      virtualisation.oci-containers.containers = {
        authentik-server = definition {
          cmd = ["server"];
          volumes = [
            "/var/lib/authentik/media:/media"
            "/var/lib/authentik/templates:/templates"
          ];
        };
        authentik-worker = definition {
          cmd = ["worker"];
          dependsOn = [
            "authentik-server"
          ];
          volumes = [
            "/var/lib/authentik/media:/media"
            "/var/lib/authentik/certs:/certs"
            "/var/lib/authentik/templates:/templates"
          ];
        };
      };

      systemd.services.podman-authentik-server = {
        after = ["network-online.target"];
        wants = ["network-online.target"];
      };

      systemd.services.podman-authentik-worker = {
        after = ["network-online.target"];
        wants = ["network-online.target"];
      };

      # TODO do not work with authentitk
      # users = {
      #   users.authentik = {
      #     isSystemUser = true;
      #     group = "authentik";
      #     uid = 100000;
      #   };
      #   groups.authentik.gid = 100000;
      # };

      sops.secrets.authentik = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        restartUnits = [
          "podman-authentik-server.service"
          "podman-authentik-worker.service"
        ];
      };
    };
}
