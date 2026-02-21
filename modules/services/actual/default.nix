{
  config,
  lib,
  ...
}:
{
  options.aspects.services.actual.enable = lib.mkEnableOption "actual";

  config = lib.mkIf config.aspects.services.actual.enable {
    services.actual = {
      enable = true;
      openFirewall = false;
      settings = {
        hostname = "127.0.0.1";
        port = 5006;
        loginMethod = "openid";
        allowedLoginMethods = [
          "openid"
          "password"
        ];
        enforceOpenId = true;
        openId = {
          server_hostname = "https://budget.tekila.ovh";
          discoveryURL = "https://auth.tekila.ovh/application/o/actual/.well-known/openid-configuration";
          # Cant use $CREDENTIALS_DIRECTORY because utils.genJqSecretsReplacementSnippet use singlequotes for this service
          client_id._secret = "/run/credentials/actual.service/client_id";
          client_secret._secret = "/run/credentials/actual.service/client_secret";
          authMethod = "openid";
        };
      };
    };

    systemd.services.actual.serviceConfig.LoadCredential = [
      "client_id:${config.sops.secrets."actual/client_id".path}"
      "client_secret:${config.sops.secrets."actual/client_secret".path}"
    ];

    sops.secrets = {
      "actual/client_id" = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        restartUnits = [ "actual.service" ];
      };
      "actual/client_secret" = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        restartUnits = [ "actual.service" ];
      };
    };

    services.nginx.virtualHosts = {
      "budget.tekila.ovh" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.actual.settings.port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
