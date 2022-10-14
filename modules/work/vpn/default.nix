{ config, lib, ... }: {
  options = {
    aspects.work.vpn.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.vpn.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".local/share/networkmanagement/certificates"
    ];
  };
}
