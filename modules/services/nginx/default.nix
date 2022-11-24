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
        proxy = {
          port,
          protect ? true,
        }:
          base {
            "= /oauth2/auth" = {
              extraConfig = ''
                proxy_pass       http://127.0.0.1:4180;
                proxy_set_header Host             $host;
                proxy_set_header X-Real-IP        $remote_addr;
                proxy_set_header X-Scheme         $scheme;
                # nginx auth_request includes headers but not body
                proxy_set_header Content-Length   "";
                proxy_pass_request_body           off;
              '';
            };
            "/oauth2/" = {
              extraConfig = ''
                proxy_pass       http://127.0.0.1:4180;
                proxy_set_header Host                    $host;
                proxy_set_header X-Real-IP               $remote_addr;
                proxy_set_header X-Scheme                $scheme;
                proxy_set_header X-Auth-Request-Redirect $scheme://$host$request_uri;
              '';
            };
            "/" = {
              proxyPass = "http://127.0.0.1:" + toString port + "/";
              extraConfig = lib.mkIf protect ''
                auth_request /oauth2/auth;
                error_page 401 = https://auth.tekila.ovh/oauth2/sign_in?rd=$scheme://$host$request_uri; # Specify full url to only have one auth domain

                auth_request_set $user   $upstream_http_x_auth_request_user;
                auth_request_set $email  $upstream_http_x_auth_request_email;
                proxy_set_header X-User  $user;
                proxy_set_header X-Email $email;

                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header Set-Cookie $auth_cookie;

                auth_request_set $auth_cookie_name_upstream_1 $upstream_cookie_auth_cookie_name_1;

                if ($auth_cookie ~* "(; .*)") {
                    set $auth_cookie_name_0 $auth_cookie;
                    set $auth_cookie_name_1 "auth_cookie_name_1=$auth_cookie_name_upstream_1$1";
                }

                if ($auth_cookie_name_upstream_1) {
                    add_header Set-Cookie $auth_cookie_name_0;
                    add_header Set-Cookie $auth_cookie_name_1;
                }
              '';
            };
          };
      in {
        "sonarr.tekila.ovh" = proxy {port = 8989;};
        "radarr.tekila.ovh" = proxy {port = 7878;};
        "bazarr.tekila.ovh" = proxy {port = 6767;};
        "prowlarr.tekila.ovh" = proxy {port = 9696;};
        "auth.tekila.ovh" = proxy {
          port = 4180;
          protect = false;
        };
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
