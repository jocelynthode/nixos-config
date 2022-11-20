{
  config,
  lib,
  ...
}: {
  options = {
    aspects.work.vpn.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.vpn.enable {
    aspects.base.persistence.homePaths = [
      ".local/share/networkmanagement/certificates"
    ];
  };
}
