{
  config,
  lib,
  pkgs-stable,
  ...
}:
{
  options.aspects.games.bottles.enable = lib.mkEnableOption "bottles";

  config = lib.mkIf config.aspects.games.bottles.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.local/share/bottles" ];

    aspects.base.persistence.homePaths = [
      ".local/share/bottles"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs-stable; [ bottles ];
    };
  };
}
