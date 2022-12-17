{
  config,
  lib,
  ...
}: {
  options.aspects.services.navidrome.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.navidrome.enable {
    services.navidrome = {
      enable = true;
      settings = {
        Address = "127.0.0.1";
        Port = 4533;
        MusicFolder = "/var/www/dde/Media/Music";
        ReverseProxyUserHeader = "X-authentik-username";
        ReverseProxyWhitelist = "127.0.0.1/32";
        EnableStarRating = false;
      };
    };

    systemd.services.navidrome.serviceConfig.EnvironmentFile = config.sops.secrets.navidrome.path;

    sops.secrets.navidrome = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      mode = "0644";
      restartUnits = ["navidrome.service"];
    };
  };
}
