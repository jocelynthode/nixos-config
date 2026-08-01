{ config, lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.aspects.base.backup = {
    includePaths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Paths (relative to the persist prefix) to include in backups.";
    };

    excludePaths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Paths (relative to the persist prefix) to exclude from backups.";
    };
  };

  config =
    let
      prefix = config.aspects.base.persistence.persistPrefix;
    in
    {
      services.restic.backups = {
        persist = {
          repositoryFile = config.sops.secrets."restic/repository".path;
          user = "root";
          paths = [ prefix ];
          exclude = [
            "${prefix}/var/cache"
            "${prefix}/var/log"
            "${prefix}/var/lib/*"
            "!${prefix}/var/lib/private"
          ]
          ++ (map (p: "!${prefix}${p}") config.aspects.base.backup.includePaths)
          ++ (map (p: "${prefix}${p}") config.aspects.base.backup.excludePaths)
          ++ [
            "${prefix}/home/jocelyn/.local/state"
            "${prefix}/home/jocelyn/.cache"
            "${prefix}/root"
          ];
          initialize = true;
          passwordFile = config.sops.secrets."restic/password".path;
          timerConfig = {
            OnCalendar = "*-*-* 12:00:00";
            Persistent = true;
            RandomizedDelaySec = "1800";
          };
          pruneOpts = [
            "--keep-daily 7"
            "--keep-weekly 4"
            "--keep-monthly 3"
          ];
          environmentFile = config.sops.secrets."restic/env".path;
        };
      };

      systemd.services.restic-backups-persist = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };
    };
}
