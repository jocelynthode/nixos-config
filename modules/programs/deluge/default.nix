{ config, lib, pkgs, ... }: {
  options.aspects.programs.deluge.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.deluge.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/deluge"
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.deluge ];
    };
  };
}
