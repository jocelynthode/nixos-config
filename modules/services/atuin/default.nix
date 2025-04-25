{
  config,
  lib,
  ...
}: {
  options.aspects.services.atuin.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.atuin.enable {
    services.postgresql = {
      ensureDatabases = [
        "atuin"
      ];
      ensureUsers = [
        {
          name = "atuin";
          ensureDBOwnership = true;
        }
      ];
    };

    services = {
      atuin = {
        enable = true;
        openRegistration = false;
        host = "127.0.0.1";
        database.uri = "postgresql:///atuin?host=/run/postgresql";
      };
      nginx.virtualHosts."atuin.tekila.ovh" = {
        onlySSL = true;
        enableACME = true;
        locations = {
          "/" = {proxyPass = "http://127.0.0.1:8888/";};
        };
      };
    };
  };
}
