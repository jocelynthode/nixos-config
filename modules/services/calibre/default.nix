{
  config,
  lib,
  ...
}: {
  options.aspects.services.calibre-web.enable = lib.mkEnableOption "calibre-web";

  config = lib.mkIf config.aspects.services.calibre-web.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/calibre-web";
        user = "calibre-web";
        group = "media";
      }
    ];

    services.calibre-web = {
      enable = true;
      openFirewall = true;
      group = "media";
      options = {
        calibreLibrary = "/data/media/books";
        enableBookUploading = true;
      };
      listen.ip = "0.0.0.0";
    };
  };
}
