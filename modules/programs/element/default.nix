{ config, lib, pkgs, ... }: {
  options.aspects.programs.element.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.element.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/Element"
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.element-desktop ];
    };
  };
}
