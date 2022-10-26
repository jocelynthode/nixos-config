{ config, lib, ... }: {
  options.aspects.base.persistence = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };

    persistPrefix = lib.mkOption {
      default = "/persist";
      example = "/persist";
    };

    homePaths = lib.mkOption {
      default = [ ];
      example = [
        { directory = ".config/syncthing"; mode = "0700"; }
        ".config/tasks"
      ];
    };

    systemPaths = lib.mkOption {
      default = [ ];
      example = [
        { directory = "/var/lib/docker"; mode = "0700"; }
        "/var/lib/systemd"
      ];
    };
  };

  config = lib.mkIf config.aspects.base.persistence.enable {
    aspects.base.persistence.persistPrefix = lib.mkDefault "/persist";

    environment.persistence."${config.aspects.base.persistence.persistPrefix}" = {
      hideMounts = true;
      directories = config.aspects.base.persistence.systemPaths;
      users.jocelyn.directories = config.aspects.base.persistence.homePaths;
    };
  };
}
