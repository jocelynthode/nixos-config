{ config, lib, pkgs, ... }: {
  options.aspects.programs.signal.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.signal.enable {
    aspects.base.persistence.homePaths = [
        { directory = ".config/Signal"; mode = "0700"; }
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.signal-desktop ];
    };
  };
}
