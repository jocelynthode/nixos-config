{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.games.lutris.enable = lib.mkEnableOption "lutris";

  config = lib.mkIf config.aspects.games.lutris.enable {
    aspects.base.persistence.homePaths = [
      ".config/lutris"
      ".local/share/lutris"
      ".wine"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [ lutris ];
    };
  };
}
