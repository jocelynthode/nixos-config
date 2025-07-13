{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.deluge.enable = lib.mkEnableOption "deluge";

  config = lib.mkIf config.aspects.programs.deluge.enable {
    aspects.base.persistence.homePaths = [
      ".config/deluge"
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs.deluge ];
    };
  };
}
