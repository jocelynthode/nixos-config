{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.games.bottles.enable = lib.mkEnableOption "bottles";

  config = lib.mkIf config.aspects.games.bottles.enable {
    aspects.base.persistence.homePaths = [
      ".local/share/bottles"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [bottles];
    };
  };
}
