{ config, lib, pkgs, ... }: {
  options.aspects.programs.calibre.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.calibre.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/calibre"
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.calibre ];
    };
  };
}
