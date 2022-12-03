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
            "/outpost.goauthentik.io" = {
              extraConfig = ''
                proxy_pass              http://127.0.0.1:9000;
                proxy_set_header        Host $host;
                proxy_set_header        X-Original-URL $scheme://$http_host$request_uri;
                add_header              Set-Cookie $auth_cookie;
                auth_request_set        $auth_cookie $upstream_http_set_cookie;
                proxy_pass_request_body off;
                proxy_set_header        Content-Length "";
              '';
            };
            "@goauthentik_proxy_signin" = {
              extraConfig = ''
                internal;
                add_header Set-Cookie $auth_cookie;
                return 302 https://auth.tekila.ovh/outpost.goauthentik.io/start?rd=$scheme://$http_host$request_uri;
              '';
            };
            # "/api".proxyPass = "http://127.0.0.1:" + toString port;
            "/" = {
              proxyPass = "http://127.0.0.1:" + toString port;
              proxyWebsockets = true;
              extraConfig = lib.mkIf protect ''
                auth_request /outpost.goauthentik.io/auth/nginx;
                error_page       401 = @goauthentik_proxy_signin;
                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header       Set-Cookie $auth_cookie;

                # translate headers from the outposts back to the actual upstream
                auth_request_set $authentik_username $upstream_http_x_authentik_username;
                auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
                auth_request_set $authentik_email $upstream_http_x_authentik_email;
                auth_request_set $authentik_name $upstream_http_x_authentik_name;
                auth_request_set $authentik_uid $upstream_http_x_authentik_uid;

                proxy_set_header X-authentik-username $authentik_username;
                proxy_set_header X-authentik-groups $authentik_groups;
                proxy_set_header X-authentik-email $authentik_email;
                proxy_set_header X-authentik-name $authentik_name;
                proxy_set_header X-authentik-uid $authentik_uid;
              '';
            };
          };
      in {
        "sonarr.tekila.ovh" = proxy {port = 8989;};
        "radarr.tekila.ovh" = proxy {port = 7878;};
        "bazarr.tekila.ovh" = proxy {port = 6767;};
        "lidarr.tekila.ovh" = proxy {port = 8686;};
        "prowlarr.tekila.ovh" = proxy {port = 9696;};
        "navi.tekila.ovh" = proxy {port = 4533;};
        "auth.tekila.ovh" = proxy {
          port = 9000;
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
