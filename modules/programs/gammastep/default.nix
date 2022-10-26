{ config, lib, ... }: {
  options.aspects.programs.gammastep.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.gammastep.enable {
    services.geoclue2.enable = true;

    home-manager.users.jocelyn = { ... }: {
      services.gammastep = {
        enable = true;
        provider = "geoclue2";
        enableVerboseLogging = true;
        temperature = {
          day = 6000;
          night = 4600;
        };
        settings = {
          general.adjustment-method = "randr";
        };
      };
    };
  };
}
