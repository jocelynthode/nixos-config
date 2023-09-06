{
  config,
  lib,
  ...
}: {
  options.aspects.services.adguard.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.adguard.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
    };
  };
}
