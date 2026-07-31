{
  config,
  lib,
  ...
}:
{
  options.aspects.programs.calibre.enable = lib.mkEnableOption "calibre";

  config = lib.mkIf config.aspects.programs.calibre.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.config/calibre" ];

    aspects.base.persistence.homePaths = [
      ".config/calibre"
    ];
    home-manager.users.jocelyn = _: {
      # home.packages = [ pkgs.calibre ];
    };
  };
}
