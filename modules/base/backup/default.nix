{config, ...}: {
  services.restic.backups = {
    persist = {
      repositoryFile = config.sops.secrets."restic/repository".path;
      user = "root";
      paths = [config.aspects.base.persistence.persistPrefix];
      exclude = [
        "/persist/var/cache"
        "/persist/var/log"
        "/persist/var/lib/*"
        "!/persist/var/lib/authentik"
        "!/persist/var/lib/hass"
        "!/persist/var/lib/private"
        "/persist/var/lib/private/ollama"
        "/persist/var/lib/private/prowlarr"
        "/persist/var/lib/private/navidrome"
        "/persist/var/lib/private/fwupd"
        "/persist/var/lib/private/esphome/.platformio"
        "/persist/var/lib/private/esphome/.esphome"
        "!/persist/var/lib/radicale"
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
        "/persist/home/jocelyn/.local/state"
        "/persist/home/jocelyn/.cache"
        "/persist/home/jocelyn/.wine"
        "/persist/home/jocelyn/.android"
        "/persist/home/jocelyn/.cargo"
        "/persist/home/jocelyn/.xlcore"
        "/persist/home/jocelyn/Astral Ascent"
        "/persist/home/jocelyn/.config/vesktop"
        "/persist/home/jocelyn/.config/ArmCord"
        "/persist/root"
        "/data"
        "/scratch"
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
}
