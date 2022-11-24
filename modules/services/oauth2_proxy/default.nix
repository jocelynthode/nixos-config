{
  config,
  lib,
  ...
}: {
  options.aspects.services.oauth2_proxy.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.oauth2_proxy.enable {
    services.oauth2_proxy = {
      enable = true;
      reverseProxy = true;
      provider = "google";
      keyFile = config.sops.secrets."oauth2/env".path;
      cookie = {
        domain = ".tekila.ovh";
        refresh = "48h0m0s";
      };
      redirectURL = "https://auth.tekila.ovh/oauth2/callback";
      extraConfig = {
        authenticated-emails-file = config.sops.secrets."oauth2/emails".path;
        whitelist-domain = "*.tekila.ovh";
        skip-provider-button = true;
      };
    };

    sops.secrets."oauth2/env" = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "oauth2_proxy";
      group = "oauth2_proxy";
      restartUnits = ["oauth2_proxy.service"];
    };

    sops.secrets."oauth2/emails" = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "oauth2_proxy";
      group = "oauth2_proxy";
      restartUnits = ["oauth2_proxy.service"];
    };
  };
}
