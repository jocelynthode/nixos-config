{
  config,
  lib,
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
      {
        directory = "/var/backup/postgresql";
        user = "postgres";
        group = "postgres";
      }
    ];
    services.postgresql = {
      enable = true;
    };

    services.postgresqlBackup = {
      enable = true;
      location = "/var/backup/postgresql";
      startAt = "*-*-* 11:15:00"; # Before restic at 12:00:00
      databases = config.services.postgresql.ensureDatabases;
    };
  };
}
