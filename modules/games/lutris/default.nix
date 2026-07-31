{
  config,
  lib,
  pkgs-stable,
  ...
}:
{
  options.aspects.games.lutris.enable = lib.mkEnableOption "lutris";

  config = lib.mkIf config.aspects.games.lutris.enable {
    aspects.base.backup.excludePaths = [
      "/home/jocelyn/.local/lutris"
      "/home/jocelyn/.wine"
    ];

    aspects.base.persistence.homePaths = [
      ".config/lutris"
      ".local/share/lutris"
      ".wine"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs-stable; [ lutris ];
    };
  };
}
