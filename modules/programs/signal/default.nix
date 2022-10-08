{ config, lib, pkgs, ... }: {
  options.aspects.programs.signal.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.signal.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
        { directory = ".config/Signal"; mode = "0700"; }
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.signal-desktop ];
    };
  };
}
