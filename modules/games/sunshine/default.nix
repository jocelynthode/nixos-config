{
  config,
  lib,
  ...
}:
{
  options.aspects.games.sunshine.enable = lib.mkEnableOption "sunshine";

  config = lib.mkIf config.aspects.games.sunshine.enable {
    aspects.base.persistence.homePaths = [
      ".config/sunshine"
    ];

    services.sunshine = {
      enable = false;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
