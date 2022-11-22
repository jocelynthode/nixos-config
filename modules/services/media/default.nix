{
  config,
  lib,
  ...
}: {
  options.aspects.services.media.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.media.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/sonarr"
      "/var/lib/radarr"
      "/var/lib/bazarr"
      "/var/lib/jackett"
    ];

    services = {
      radarr = {
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
      bazarr = {
        enable = true;
        openFirewall = true;
      };
      jackett = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
