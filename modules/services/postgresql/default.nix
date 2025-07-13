{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.services.postgresql.enable = lib.mkEnableOption "postgresql";

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
      package = pkgs.postgresql_15;
    };

    services.postgresqlBackup = {
      enable = true;
      location = "/backups/postgresql";
      startAt = "*-*-* 11:15:00"; # Before restic at 12:00:00
      databases = config.services.postgresql.ensureDatabases;
    };
  };
}
