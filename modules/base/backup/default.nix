{config, ...}: {
  services.restic.backups = {
    persist = {
      repositoryFile = config.sops.secrets."restic/repository".path;
      user = "root";
      paths = [config.aspects.base.persistence.persistPrefix];
      exclude = [
        "/persist/.snapshots"
        "/persist/var"
        "/persist/home/jocelyn/go"
        "/persist/home/jocelyn/Downloads"
        "/persist/home/jocelyn/Liip"
        "/persist/home/jocelyn/Pictures"
        "/persist/home/jocelyn/Documents"
        "/persist/home/jocelyn/Music"
        "/persist/home/jocelyn/Programs"
        "/persist/home/jocelyn/.local/share/Steam"
        "/persist/home/jocelyn/.local/share/containers"
        "/persist/home/jocelyn/.local/lutris"
        "/persist/home/jocelyn/.cache"
        "/persist/home/jocelyn/.wine"
        "/persist/home/jocelyn/.android"
      ];
      initialize = true;
      passwordFile = config.sops.secrets."restic/password".path;
      timerConfig = {
        OnCalendar = "*-*-* 12:00:00";
        Persistent = true;
        RandomizedDelaySec = "600";
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
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };

  services.snapper = {
    configs = {
      persist = {
        subvolume = config.aspects.base.persistence.persistPrefix;
        extraConfig = ''
          ALLOW_USERS="jocelyn"
          TIMELINE_CREATE="yes"
          TIMELINE_CLEANUP="yes"
          TIMELINE_LIMIT_HOURLY="10"
          TIMELINE_LIMIT_DAILY="3"
          TIMELINE_LIMIT_WEEKLY="0"
          TIMELINE_LIMIT_MONTHLY="0"
          TIMELINE_LIMIT_YEARLY="0"
        '';
      };
    };
  };
}
