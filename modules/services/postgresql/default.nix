{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.services.postgresql.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.postgresql.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
      }
    ];
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
      ensureDatabases = [
        "authentik"
        "atuin"
      ];
      ensureUsers = [
        {
          name = "authentik";
          ensureDBOwnership = true;
        }
        {
          name = "atuin";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
