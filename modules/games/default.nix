{
  config,
  lib,
  ...
}: {
  imports = [
    ./bottles
    ./discord
    ./gamemode
    ./lutris
    ./mumble
    ./ryujinx
    ./steam
  ];

  options.aspects.games.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.enable {
    aspects.games = {
      bottles.enable = lib.mkDefault true;
      discord.enable = lib.mkDefault true;
      gamemode.enable = lib.mkDefault true;
      lutris.enable = lib.mkDefault true;
      mumble.enable = lib.mkDefault true;
      ryujinx.enable = lib.mkDefault false;
      steam.enable = lib.mkDefault true;
    };
  };
}
