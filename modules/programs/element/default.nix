{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.element.enable = lib.mkEnableOption "element";

  config = lib.mkIf config.aspects.programs.element.enable {
    aspects.base.persistence.homePaths = [
      ".config/Element"
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs.element-desktop ];
    };
  };
}
