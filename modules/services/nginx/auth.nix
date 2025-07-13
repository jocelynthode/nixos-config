{ lib, ... }:
{
  port,
  protect ? true,
  extraPaths ? { },
}:
let
  defaultLocations = {
    "/outpost.goauthentik.io" = {
      extraConfig = ''
        proxy_pass              http://127.0.0.1:9000;
        proxy_set_header        Host $host;
        proxy_set_header        X-Original-URL $scheme://$http_host$request_uri;
        auth_request_set        $auth_cookie $upstream_http_set_cookie;
        add_header              Set-Cookie $auth_cookie;
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

    "/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      extraConfig = lib.concatStringsSep "\n" (
        lib.optionals protect [
          ''
            auth_request /outpost.goauthentik.io/auth/nginx;
            error_page       401 = @goauthentik_proxy_signin;
            auth_request_set $auth_cookie $upstream_http_set_cookie;
            add_header       Set-Cookie $auth_cookie;

            # forward authenticated headers
            auth_request_set $authentik_username $upstream_http_x_authentik_username;
            auth_request_set $authentik_groups   $upstream_http_x_authentik_groups;
            auth_request_set $authentik_email    $upstream_http_x_authentik_email;
            auth_request_set $authentik_name     $upstream_http_x_authentik_name;
            auth_request_set $authentik_uid      $upstream_http_x_authentik_uid;

            proxy_set_header X-authentik-username $authentik_username;
            proxy_set_header X-authentik-groups   $authentik_groups;
            proxy_set_header X-authentik-email    $authentik_email;
            proxy_set_header X-authentik-name     $authentik_name;
            proxy_set_header X-authentik-uid      $authentik_uid;

            proxy_send_timeout 600s;
            proxy_read_timeout 600s;
            keepalive_timeout 21600s;
          ''
        ]
        ++ [
          (if extraPaths ? "/" then extraPaths."/".extraConfig else "")
        ]
      );
    };
  };
in
{
  forceSSL = true;
  enableACME = true;
  locations = lib.recursiveUpdate defaultLocations extraPaths;
}
