{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.games.ryujinx.enable = lib.mkEnableOption "ryujinx";

  config = lib.mkIf config.aspects.games.ryujinx.enable {
    aspects.base.persistence.homePaths = [
      ".config/Ryujinx"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [ ryujinx ];
    };
  };
}
