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
      };
    };
  };
}
