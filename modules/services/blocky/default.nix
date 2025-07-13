{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.services.blocky.enable = lib.mkEnableOption "blocky";

  config =
    let
      allowlist = pkgs.writeText "whitelist.txt" ''
        s.youtube.com
      '';
      denylist = pkgs.writeText "blacklist.txt" ''
        # Remove Microsoft VSCode tunnel access
        /^(.+[_.-])?tunnels\.api\.visualstudio\.com/
        /^(.+[_.-])?devtunnels\.ms/
      '';
    in
    lib.mkIf config.aspects.services.blocky.enable {
      networking = {
        firewall = {
          allowedTCPPorts = [
            53
            853
          ];
          allowedUDPPorts = [ 53 ];
        };
        # Prevent things from not resolving prior to blocky start
        networkmanager.insertNameservers = [
          "94.140.14.140"
          "76.76.2.0"
        ];
      };

      services.nginx = {
        virtualHosts."dns.tekila.ovh" = {
          onlySSL = true;
          enableACME = true;
          locations = {
            "/dns-query" = {
              proxyPass = "https://127.0.0.1:4443/dns-query";
            };
          };
        };
        streamConfig = ''
          server {
            listen 0.0.0.0:853 ssl;
            listen [::]:853 ssl;
            proxy_ssl on;
            proxy_pass 127.0.0.1:8853;
            ssl_certificate         /var/lib/acme/dns.tekila.ovh/fullchain.pem;
            ssl_certificate_key     /var/lib/acme/dns.tekila.ovh/key.pem;
            ssl_trusted_certificate /var/lib/acme/dns.tekila.ovh/chain.pem;
          }
        '';
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
            ips = [
              "194.242.2.2"
              "194.0.5.3"
            ];
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
              ads = [ "${allowlist}" ];
            };
            clientGroupsBlock = {
              default = [ "ads" ];
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
