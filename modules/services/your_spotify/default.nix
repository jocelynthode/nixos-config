{
  config,
  lib,
  ...
}: {
  options.aspects.services.your_spotify.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.your_spotify.enable {
    services.your_spotify = {
      enable = false;
      spotifySecretFile = config.sops.secrets.your_spotify.path;
      enableLocalDB = true;
      settings = {
        SPOTIFY_PUBLIC = "70d77cb88a934ccf9524807a4b5b132f";
        CLIENT_ENDPOINT = "https://spotify.tekila.ovh";
        API_ENDPOINT = "https://spotify.tekila.ovh/api";
      };
      nginxVirtualHost = "spotify.tekila.ovh";
    };

    sops.secrets.your_spotify = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      mode = "0644";
      restartUnits = ["your_spotify.service"];
    };

    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/db/mongodb";
        user = "mongodb";
        group = "mongodb";
      }
    ];
  };
}
