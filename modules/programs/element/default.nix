{ config, lib, pkgs, ... }: {
  options.aspects.programs.element.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.element.enable {
    aspects.base.persistence.homePaths = [
      ".config/Element"
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.element-desktop ];
    };
  };
}
