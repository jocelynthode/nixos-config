{
  config,
  lib,
  ...
}: {
  options.aspects.services.blocky.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.blocky.enable {
    networking = {
      firewall = {
        allowedTCPPorts = [53];
        allowedUDPPorts = [53];
      };
    };

    services.blocky = {
      enable = true;
      settings = {
        ports = {
          dns = 53;
          https = 4443;
        };
        upstream.default = [
          "https://dns10.quad9.net/dns-query"
          "https://dns.mullvad.net/dns-query"
          "https://one.one.one.one/dns-query"
          "https://dns.google/dns-query"
        ];
        # For initially solving DoH/DoT Requests when no system Resolver is available.
        bootstrapDns = {
          upstream = "https://dns.quad9.net/dns-query";
          ips = ["9.9.9.9" "149.112.112.112"];
        };
        blocking = {
          blackLists = {
            ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          };
          clientGroupsBlock = {
            default = ["ads"];
          };
        };
        log = {
          privacy = true;
        };
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };
      };
    };
  };
}
