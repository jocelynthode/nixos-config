{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.services.jellyfin.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.jellyfin.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
      }
    ];
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
  };
}
