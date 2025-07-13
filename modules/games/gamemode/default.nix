{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.games.gamemode.enable = lib.mkEnableOption "gamemode";

  config = lib.mkIf config.aspects.games.gamemode.enable {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
