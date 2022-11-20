{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.calibre.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.calibre.enable {
    aspects.base.persistence.homePaths = [
      ".config/calibre"
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [pkgs.calibre];
    };
  };
}
