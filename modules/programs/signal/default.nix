{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.signal.enable = lib.mkEnableOption "signal";

  config = lib.mkIf config.aspects.programs.signal.enable {
    aspects.base.persistence.homePaths = [
      {
        directory = ".config/Signal";
        mode = "0700";
      }
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs.signal-desktop ];
    };
  };
}
