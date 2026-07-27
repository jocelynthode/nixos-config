{
  config,
  lib,
  pkgs-master,
  ...
}:
{
  options.aspects.programs.element.enable = lib.mkEnableOption "element";

  config = lib.mkIf config.aspects.programs.element.enable {
    aspects.base.persistence.homePaths = [
      ".config/Element"
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs-master.element-desktop ];
    };
  };
}
