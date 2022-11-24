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

          extraConfig = ''
            ssl_stapling on;
            ssl_stapling_verify on;
          '';
          forceSSL = true;
          enableACME = true;
        };
        proxy = port:
          base {
            "/oauth2/auth" = {
              extraConfig = ''
                internal;
                proxy_pass       http://127.0.0.1:4180;
                proxy_set_header Host             $host;
                proxy_set_header X-Real-IP        $remote_addr;
                proxy_set_header X-Scheme         $scheme;
                # nginx auth_request includes headers but not body
                proxy_set_header Content-Length   "";
                proxy_pass_request_body           off;
              '';
            };
            "/" = {
              proxyPass = "http://127.0.0.1:" + toString port + "/";
              extraConfig = ''
                auth_request /oauth2/auth;

                auth_request_set $email  $upstream_http_x_auth_request_email;
                proxy_set_header X-Email $email;
                auth_request_set $user  $upstream_http_x_auth_request_user;
                proxy_set_header X-User  $user;
                auth_request_set $token  $upstream_http_x_auth_request_access_token;
                proxy_set_header X-Access-Token $token;
                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header Set-Cookie $auth_cookie;
              '';
            };
          };
      in {
        "sonarr.tekila.ovh" = proxy 8989;
        "radarr.tekila.ovh" = proxy 7878;
        "bazarr.tekila.ovh" = proxy 6767;
        "prowlarr.tekila.ovh" = proxy 9696;
        "servetek.home" = {
          root = "/var/www/dde";
          default = true;
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
