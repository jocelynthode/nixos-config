{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.games.discord.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.discord.enable {
    aspects.base.persistence.homePaths = [
      ".config/ArmCord"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [armcord];
    };
  };
}
