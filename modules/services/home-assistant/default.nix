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
      {
        directory = "/var/lib/zigbee2mqtt";
      }
      {
        directory = "/var/lib/mosquitto";
      }
    ];

    networking.firewall.allowedTCPPorts = [8080];

    services = {
      esphome = {
        enable = true;
        address = "0.0.0.0";
        openFirewall = true;
      };
      mosquitto = {
        enable = true;
        listeners = [
          {
            address = "127.0.0.1";
            acl = ["topic readwrite #"];
            settings = {
              allow_anonymous = false;
            };
            users = {
              hass = {
                acl = [
                  "readwrite #"
                ];
                passwordFile = config.sops.secrets."mqtt/hass".path;
              };
              "${config.services.zigbee2mqtt.settings.mqtt.user}" = {
                acl = [
                  "readwrite #"
                ];
                passwordFile = config.sops.secrets."mqtt/zigbee2mqtt".path;
              };
            };
          }
        ];
      };
      zigbee2mqtt = {
        enable = true;
        settings = {
          homeassistant = config.services.home-assistant.enable;
          permit_join = false;
          frontend = true;
          advanced = {
            log_level = "info";
            log_namespaced_levels = {
              "z2m:mqtt" = "warning";
            };
          };
          device_options = {
            retain = true;
          };
          mqtt = {
            base_topic = "zigbee2mqtt";
            server = "mqtt://localhost:1883";
            user = "zigbee2mqtt";
            password = "!secret password";
          };
          serial = {
            port = "/dev/serial/by-id/usb-Nabu_Casa_SkyConnect_v1.0_0222f2dc9bb3ed11977243aca7669f5d-if00-port0";
            adapter = "ember";
            rtscts = false;
          };
        };
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
          "airvisual"
          "brother"
          "co2signal"
          "dlna_dmr"
          "esphome"
          "homeassistant_sky_connect"
          "ipp"
          "jellyfin"
          "kodi"
          "met"
          "twinkly"
          "upnp"
          "utility_meter"
          "mqtt"
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

    sops.secrets = {
      "mqtt/hass" = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        owner = "mosquitto";
        restartUnits = ["mosquitto.service"];
      };
      "mqtt/zigbee2mqtt" = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        owner = "mosquitto";
        restartUnits = ["mosquitto.service"];
      };
      zigbee2mqtt = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        path = "/var/lib/zigbee2mqtt/secret.yaml";
        owner = "${config.systemd.services.zigbee2mqtt.serviceConfig.User}";
        group = "${config.systemd.services.zigbee2mqtt.serviceConfig.Group}";
        restartUnits = ["zigbee2mqtt.service"];
      };
      home-assistant = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
        owner = "hass";
        path = "/var/lib/hass/secrets.yaml";
        restartUnits = ["home-assistant.service"];
      };
    };
  };
}
