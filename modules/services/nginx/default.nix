{
  config,
  lib,
  ...
}: {
  options.aspects.services.nginx.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.nginx.enable {
    networking.firewall.allowedTCPPorts = [8080];
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      commonHttpConfig = ''
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
      '';
      virtualHosts = let
        base = locations: {
          inherit locations;

          forceSSL = true;
          enableACME = true;
        };
        proxy = port:
          base {
            "/".proxyPass = "http://127.0.0.1:" + toString port + "/";
          };
      in {
        "sonarr.tekila.ovh" = proxy 8989 // {default = true;};
        "radarr.tekila.ovh" = proxy 7878 // {default = true;};
        "bazarr.tekila.ovh" = proxy 6767 // {default = true;};
        "prowlarr.tekila.ovh" = proxy 9696 // {default = true;};
        "tekila.ovh" = {
          root = "/var/www/dde";
          listen = [
            {
              port = 8080;
              addr = "0.0.0.0";
              ssl = false;
            }
          ];
          locations."/" = {
            extraConfig = ''
              autoindex on;
              autoindex_exact_size on;
            '';
          };
        };
      };
    };
  };
}
