{
  config,
  lib,
  ...
}: {
  options.aspects.programs.gammastep.enable = lib.mkEnableOption "gammastep";

  config = lib.mkIf config.aspects.programs.gammastep.enable {
    services.geoclue2.enable = true;

    home-manager.users.jocelyn = _: {
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
