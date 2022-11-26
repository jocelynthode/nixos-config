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
      "/var/lib/postgresql"
    ];

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
      ensureDatabases = [
        "authentik"
      ];
      ensureUsers = [
        {
          name = "authentik";
          ensurePermissions = {
            "DATABASE authentik" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}
