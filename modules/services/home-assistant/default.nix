{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.services.home-assistant.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.home-assistant.enable {
    aspects.base.persistence.systemPaths = [
      {
        directory = "/var/lib/hass";
        user = "hass";
        group = "hass";
      }
    ];

    services = {
      esphome = {
        enable = true;
        address = "0.0.0.0";
        openFirewall = true;
      };
      postgresql = {
        ensureDatabases = [
          "hass"
        ];
        ensureUsers = [
          {
            name = "hass";
            ensureDBOwnership = true;
          }
        ];
      };
      home-assistant = {
        enable = true;
        openFirewall = true;
        package = pkgs.home-assistant.override {extraPackages = ps: [ps.psycopg2];};
        extraComponents = [
          # Components required to complete the onboarding
          "esphome"
          "co2signal"
          "twinkly"
          "utility_meter"
          "zha"
          "kodi"
          "brother"
          "dlna_dmr"
          "upnp"
          "ipp"
          "jellyfin"
        ];
        customComponents = with pkgs.home-assistant-custom-components; [
          auth-header
        ];
        config = {
          recorder = {
            db_url = "postgresql://@/hass";
            purge_keep_days = 30;
          };
          # https://www.home-assistant.io/integrations/default_config/
          default_config = {};
          api = {};
          "automation ui" = "!include automations.yaml";
          http = {
            use_x_forwarded_for = true;
            trusted_proxies = [
              "127.0.0.1"
              "::1"
            ];
          };
          auth_header = {
            username_header = "X-authentik-username";
          };
        };
      };
    };

    sops.secrets.home-assistant = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";
      restartUnits = ["home-assistant.service"];
    };
  };
}
