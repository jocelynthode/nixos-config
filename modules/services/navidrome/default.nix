{
  config,
  lib,
  ...
}: let
  mkAuthProxy = import ../nginx/auth.nix {inherit lib;};
in {
  options.aspects.services.navidrome.enable = lib.mkEnableOption "navidrome";

  config = lib.mkIf config.aspects.services.navidrome.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/navidrome";
        user = "navidrome";
        group = "media";
      }
    ];

    services.navidrome = {
      enable = true;
      group = "media";
      settings = {
        Address = "127.0.0.1";
        Port = 4533;
        MusicFolder = "/data/media/music";
        ReverseProxyUserHeader = "X-authentik-username";
        ReverseProxyWhitelist = "127.0.0.1/32";
        EnableStarRating = false;
      };
    };

    services.nginx.virtualHosts."music.tekila.ovh" = mkAuthProxy {
      port = 4533;
    };

    systemd.services.navidrome.serviceConfig = {
      EnvironmentFile = config.sops.secrets.navidrome.path;
      # SupplementaryGroups = [config.users.groups.keys.name];
    };

    sops.secrets.navidrome = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      mode = "0644";
      restartUnits = ["navidrome.service"];
    };
  };
}
