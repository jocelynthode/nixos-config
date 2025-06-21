{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.services.deluge.enable = lib.mkEnableOption "deluge";

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
          listen_interface = "wg1";
          outgoing_interface = "wg1";
          stop_seed_at_ratio = true;
          random_outgoing_ports = true;
          random_port = false;
          daemon_port = 58846;
          listen_ports = [53394 53394];
          upnp = false;
          natpmp = false;
          max_download_speed = 90000;
          max_upload_speed = 70000;
          max_active_downloading = 30;
          max_active_limit = 250;
          max_active_seeding = 250;
          max_connections_global = 7500;
          max_connections_per_second = 20;
          max_connections_per_torrent = 200;
          enabled_plugins = [
            "Label"
            "AutoRemovePlus" # Manually build https://github.com/tote94/deluge-autoremoveplus and add .egg to /var/lib/deluge/.config/plugins
            "ltConfig" # https://github.com/ratanakvlun/deluge-ltconfig add .egg to /var/lib/deluge/.config/plugins
            "natpmp" # https://github.com/SloCompTech/deluge-natpmp-plugin
          ];
        };
      };
      deluge.web = {
        enable = true;
        port = 8112;
        openFirewall = true;
      };
    };

    environment.systemPackages = with pkgs; [
      libnatpmp
    ];
    # systemd.timers.natpmp = {
    #   enable = true;
    #   description = "Renew NAT-PMP port forwarding for Deluge";
    #   after = ["network.target" "deluged.service"];
    #   wantedBy = ["timers.target"];
    #
    #   timerConfig = {
    #     OnBootSec = "45s";
    #     OnUnitActiveSec = "45s";
    #     AccuracySec = "1s";
    #     RandomizedDelaySec = 0;
    #     FixedRandomDelay = false;
    #   };
    # };
    #
    # systemd.services.natpmp = {
    #   enable = true;
    #   description = "Map Deluge TCP/UDP via NAT-PMP";
    #   after = ["network.target" "deluged.service"];
    #
    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = [
    #       "${pkgs.libnatpmp}/bin/natpmpc -g 10.2.0.1 -a 1 0 udp 60"
    #       "${pkgs.libnatpmp}/bin/natpmpc -g 10.2.0.1 -a 1 0 tcp 60"
    #     ];
    #   };
    # };

    sops.secrets.deluge = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "deluge";
      group = "deluge";
      restartUnits = ["deluged.service" "delugeweb.service"];
    };
  };
}
