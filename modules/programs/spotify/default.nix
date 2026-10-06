{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.spotify.enable = lib.mkEnableOption "spotify";

  config = lib.mkIf config.aspects.programs.spotify.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.config/spotify" ];

    aspects.base.persistence.homePaths = [
      ".config/spotify"
    ];

    home-manager.sharedModules = [ ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs.playerctl ];
      services.playerctld = {
        enable = true;
      };
    };
  };
}
