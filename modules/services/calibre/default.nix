{
  config,
  lib,
  ...
}: {
  options.aspects.services.calibre-web.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.calibre-web.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/calibre-web";
        user = "calibre-web";
        group = "calibre-web";
      }
    ];

    services.calibre-web = {
      enable = true;
      openFirewall = true;
      options = {
        calibreLibrary = "/var/www/dde/Media/Ebooks";
        enableBookUploading = true;
      };
      listen.ip = "0.0.0.0";
    };
  };
}
