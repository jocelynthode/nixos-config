{
  config,
  lib,
  ...
}: {
  imports = [
    ./acme
    ./authentik
    ./ddclient
    ./deluge
    ./media
    ./nginx
    ./oauth2_proxy
    ./postgresql
    ./radicale
    ./redis
    ./taskserver
    ./wireguard
  ];

  options.aspects.services.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.enable {
    aspects = {
      services = {
        acme.enable = lib.mkDefault true;
        authentik.enable = lib.mkDefault false;
        ddclient.enable = lib.mkDefault true;
        deluge.enable = lib.mkDefault true;
        media.enable = lib.mkDefault true;
        nginx.enable = lib.mkDefault true;
        oauth2_proxy.enable = lib.mkDefault true;
        postgresql.enable = lib.mkDefault false;
        radicale.enable = lib.mkDefault true;
        redis.enable = lib.mkDefault false;
        taskserver.enable = lib.mkDefault true;
        wireguard.enable = lib.mkDefault true;
      };
    };
  };
}
