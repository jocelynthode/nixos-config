{ config, lib, pkgs, ... }: {
  options.aspects.programs.bitwarden.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.bitwarden.enable {
    aspects.base.persistence.homePaths = [
        { directory = ".config/Bitwarden"; mode = "0700"; }
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.bitwarden ];
    };
  };
}
