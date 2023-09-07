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
    networking = {
      firewall = {
        allowedTCPPorts = [3000];
        allowedUDPPorts = [53];
      };
      nameservers = ["127.0.0.1"];
    };

    services.adguardhome = {
      enable = true;
      # openFirewall = true;
    };
  };
}
