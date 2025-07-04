{
  config,
  lib,
  ...
}: {
  options.aspects.services.authentik.enable = lib.mkEnableOption "authentik";

  config = let
    definition = {
      cmd,
      dependsOn ? [],
      volumes,
    }: {
      inherit cmd volumes dependsOn;
      image = "ghcr.io/goauthentik/server:2025.6.1";
      user = "100000:100000"; # authentik:authentik
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
    mkAuthProxy = import ../nginx/auth.nix {inherit lib;};
  in
    lib.mkIf config.aspects.services.authentik.enable {
      aspects.base.persistence.systemPaths = [
        {
          directory = "/var/lib/authentik";
          user = "100000"; # basic authentik user
          group = "100000";
        }
      ];

      services.nginx.virtualHosts."auth.tekila.ovh" = mkAuthProxy {
        port = 9000;
        protect = false;
      };

      # TODO nixify these steps
      # On first run we need to set a password for the authentik database in postgresql
      # The various volumes must also be created and be owned by authentik:authentik
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
        after = ["network-online.target" "blocky.service"];
        wants = ["network-online.target" "blocky.service"];
      };

      systemd.services.podman-authentik-worker = {
        after = ["network-online.target" "blocky.service"];
        wants = ["network-online.target" "blocky.service"];
      };

      users = {
        users.authentik = {
          isSystemUser = true;
          group = "authentik";
          uid = 100000;
        };
        groups.authentik.gid = 100000;
      };

      sops.secrets.authentik = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        restartUnits = [
          "podman-authentik-server.service"
          "podman-authentik-worker.service"
        ];
      };

      services.postgresql = {
        ensureDatabases = [
          "authentik"
        ];
        ensureUsers = [
          {
            name = "authentik";
            ensureDBOwnership = true;
          }
        ];
      };
    };
}
