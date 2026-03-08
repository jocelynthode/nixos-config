{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    (inputs.import-tree.match "^/[^/]+/default\\.nix$" ./.)
  ];

  options.aspects.games.enable = lib.mkEnableOption "games";

  config = lib.mkIf config.aspects.games.enable {
    aspects.games = {
      bottles.enable = lib.mkDefault true;
      discord.enable = lib.mkDefault true;
      gamemode.enable = lib.mkDefault true;
      lutris.enable = lib.mkDefault true;
      mumble.enable = lib.mkDefault true;
      ryujinx.enable = lib.mkDefault false;
      steam.enable = lib.mkDefault true;
      sunshine.enable = lib.mkDefault false;
    };
  };
}
