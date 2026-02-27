{
  config,
  lib,
  ...
}:
{
  options.aspects.programs.calibre.enable = lib.mkEnableOption "calibre";

  config = lib.mkIf config.aspects.programs.calibre.enable {
    aspects.base.persistence.homePaths = [
      ".config/calibre"
    ];
    home-manager.users.jocelyn = _: {
      # home.packages = [ pkgs.calibre ];
    };
  };
}
