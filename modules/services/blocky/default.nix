{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.services.blocky.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = let
    allowlist =
      pkgs.writeText "whitelist.txt"
      ''
        s.youtube.com
      '';
    denylist =
      pkgs.writeText "blacklist.txt"
      ''
        # Remove Microsoft VSCode tunnel access
        /^(.+[_.-])?tunnels\.api\.visualstudio\.com/
        /^(.+[_.-])?devtunnels\.ms/
      '';
  in
    lib.mkIf config.aspects.services.blocky.enable {
      networking = {
        firewall = {
          allowedTCPPorts = [53 853];
          allowedUDPPorts = [53];
        };
      };

      services.blocky = {
        enable = true;
        settings = {
          ports = {
            dns = 53;
            https = 4443;
            tls = 8853;
          };
          upstreams.groups = {
            default = [
              "https://dns.mullvad.net/dns-query"
              "https://ns0.fdn.fr/dns-query"
              "https://ns1.fdn.fr/dns-query"
              "https://doh.dns4all.eu/dns-query"
              "https://doh.libredns.gr/dns-query"
              "https://resolver2.dns.watch/dns-query"
            ];
          };
          # For initially solving DoH/DoT Requests when no system Resolver is available.
          bootstrapDns = {
            upstream = "https://dns.mullvad.net/dns-query";
            # mullvad + dns4all
            ips = ["194.242.2.2" "194.0.5.3"];
          };
          blocking = {
            blockType = "zeroIP";
            blockTTL = "30m";
            denylists = {
              ads = [
                "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt"
                "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext&useip=0.0.0.0"
                "${denylist}"
              ];
            };
            allowlists = {
              ads = ["${allowlist}"];
            };
            clientGroupsBlock = {
              default = ["ads"];
            };
          };
          log = {
            level = "warn";
            privacy = true;
          };
        };
      };
    };
}
