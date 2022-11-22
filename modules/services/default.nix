{
  config,
  lib,
  ...
}: {
  imports = [
    ./acme
    ./ddclient
    ./deluge
    ./media
    ./nginx
    ./radicale
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
        ddclient.enable = lib.mkDefault true;
        deluge.enable = lib.mkDefault true;
        media.enable = lib.mkDefault true;
        nginx.enable = lib.mkDefault true;
        radicale.enable = lib.mkDefault true;
        taskserver.enable = lib.mkDefault true;
        wireguard.enable = lib.mkDefault true;
      };
    };
  };
}
