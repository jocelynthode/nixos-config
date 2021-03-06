{ config, hostname, ... }: {
  services.restic.backups = {
    persist = {
      user = "root";
      # repository is in environmentFile
      paths = [ "/persist" ];
      extraBackupArgs = [ "--exclude-file=/etc/restic/exclude.txt" ];
      initialize = true;
      passwordFile = config.age.secrets.restic-password.path;
      timerConfig = {
        OnCalendar = "daily";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
      environmentFile = config.age.secrets.restic-env.path;
    };
  };

  environment.etc = {
    "restic/exclude.txt" = {
      text = ''
        /persist/.snapshots
        /persist/var
        /persist/home/jocelyn/go
        /persist/home/jocelyn/Downloads
        /persist/home/jocelyn/.local/share/Steam
        /persist/home/jocelyn/.local/share/containers
        /persist/home/jocelyn/.cache
      '';
      mode = "0440";
    };
  };

  age.secrets.restic-password.file = ../secrets/restic-password.age;
  age.secrets.restic-env.file = ../secrets/restic-env.age;
}
