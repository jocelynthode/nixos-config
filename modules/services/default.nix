{
  config,
  lib,
  ...
}: {
  imports = [
    ./acme
    ./atuin
    ./audiobookshelf
    ./authentik
    ./blocky
    ./calibre
    ./ddclient
    ./deluge
    ./home-assistant
    ./jellyfin
    ./media
    ./navidrome
    ./nginx
    ./postgresql
    ./radicale
    ./recyclarr
    ./redis
    ./wireguard
    ./your_spotify
  ];

  options.aspects.services.enable = lib.mkEnableOption "services";

  config = lib.mkIf config.aspects.services.enable {
    aspects = {
      services = {
        acme.enable = lib.mkDefault true;
        atuin.enable = lib.mkDefault true;
        audiobookshelf.enable = lib.mkDefault true;
        authentik.enable = lib.mkDefault true;
        blocky.enable = lib.mkDefault true;
        calibre-web.enable = lib.mkDefault true;
        ddclient.enable = lib.mkDefault true;
        deluge.enable = lib.mkDefault true;
        home-assistant.enable = lib.mkDefault true;
        jellyfin.enable = lib.mkDefault true;
        media.enable = lib.mkDefault true;
        navidrome.enable = lib.mkDefault true;
        nginx.enable = lib.mkDefault true;
        postgresql.enable = lib.mkDefault true;
        radicale.enable = lib.mkDefault true;
        recyclarr.enable = lib.mkDefault true;
        redis.enable = lib.mkDefault true;
        wireguard.enable = lib.mkDefault true;
        your_spotify.enable = lib.mkDefault true;
      };
    };
  };
}
