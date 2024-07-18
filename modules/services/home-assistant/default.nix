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
      }
    ];

    services.postgresql = {
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

    services.home-assistant = {
      enable = true;
      openFirewall = true;
      package =
        (pkgs.home-assistant.override {
          extraPackages = py: with py; [psycopg2];
        })
        .overrideAttrs (_oldAttrs: {
          doInstallCheck = false;
        });
      config.recorder.db_url = "postgresql://@/hass";
      extraComponents = [
        # Components required to complete the onboarding
        "esphome"
        "met"
        "map"
      ];
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = {};
        api = {};
      };
    };
  };
}
