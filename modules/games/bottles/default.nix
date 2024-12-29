{
  config,
  lib,
  pkgs-stable,
  ...
}: {
  options.aspects.games.bottles.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.bottles.enable {
    aspects.base.persistence.homePaths = [
      ".local/share/bottles"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs-stable; [bottles];
    };
  };
}
