{config, ...}: {
  services.restic.backups = {
    persist = {
      repositoryFile = config.sops.secrets."restic/repository".path;
      user = "root";
      paths = [config.aspects.base.persistence.persistPrefix];
      exclude = [
        "/persist/.snapshots"
        "/persist/var/cache"
        "/persist/var/log"
        "/persist/var/lib/*"
        "!/persist/var/lib/authentik"
        "!/persist/var/lib/hass"
        "!/persist/var/lib/private"
        "/persist/var/lib/private/prowlarr"
        "/persist/var/lib/private/navidrome"
        "/persist/var/lib/private/fwupd"
        "/persist/var/lib/private/esphome/.platformio"
        "/persist/var/lib/private/esphome/.esphome"
        "!/persist/var/lib/radicale"
        "!/persist/var/lib/taskserver"
        "!/persist/var/lib/acme"
        "!/persist/var/lib/jellyfin"
        "/persist/var/lib/jellyfin/metadata"
        "/persist/home/jocelyn/.gnupg"
        "/persist/home/jocelyn/go"
        "/persist/home/jocelyn/Downloads"
        "/persist/home/jocelyn/Liip"
        "/persist/home/jocelyn/Pictures"
        "/persist/home/jocelyn/Documents"
        "/persist/home/jocelyn/Music"
        "/persist/home/jocelyn/Programs"
        "/persist/home/jocelyn/Projects/ai"
        "/persist/home/jocelyn/.local/share/Steam"
        "/persist/home/jocelyn/.local/share/containers"
        "/persist/home/jocelyn/.local/share/bottles"
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
        SUBVOLUME = config.aspects.base.persistence.persistPrefix;
        ALLOW_USERS = ["jocelyn"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 3;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
