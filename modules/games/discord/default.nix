{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.games.discord.enable = lib.mkEnableOption "discord";

  config = lib.mkIf config.aspects.games.discord.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.config/vesktop" ];

    aspects.base.persistence.homePaths = [
      ".config/vesktop"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [ vesktop ];
    };
  };
}
