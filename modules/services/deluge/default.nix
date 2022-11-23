{
  config,
  lib,
  ...
}: {
  options.aspects.services.deluge.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.deluge.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/deluge"
    ];

    networking.firewall.allowedTCPPorts = [58846];

    services = {
      deluge = {
        enable = true;
        declarative = true;
        openFirewall = true;
        authFile = config.sops.secrets.deluge.path;
        config = {
          allow_remote = true;
          download_location = "/var/www/dde/Downloads";
          listen_interface = "wg0";
          outgoing_interface = "wg0";
          stop_seed_at_ratio = true;
          random_outgoing_ports = true;
          random_port = false;
          daemon_port = 58846;
          listen_ports = [53394 53420];
          upnp = false;
          natpmp = false;
          max_download_speed = 90000;
          max_upload_speed = 50000;
          max_active_downloading = 10;
          max_active_limit = 20;
          max_active_seeding = 10;
          enabled_plugins = [
            "Label"
            "AutoRemovePlus" # Manually build https://github.com/tote94/deluge-autoremoveplus and add .egg to /var/lib/deluge/.config/plugins
          ];
        };
      };
      deluge.web = {
        enable = true;
        port = 8112;
        openFirewall = true;
      };
    };

    sops.secrets.deluge = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "deluge";
      group = "deluge";
      restartUnits = ["deluged.service" "delugeweb.service"];
    };
  };
}
