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
        group = "media";
        authFile = config.sops.secrets.deluge.path;
        config = {
          allow_remote = true;
          download_location = "/scratch/torrents";
          move_completed_path = "/data/torrents";
          move_completed = true;
          torrentfiles_location = "/data/torrents";
          copy_torrent_file = true;
          del_copy_torrent_file = true;
          pre_allocate_storage = true;
          listen_interface = "wg1";
          outgoing_interface = "wg1";
          stop_seed_at_ratio = false;
          remove_seed_at_ratio = false;
          random_outgoing_ports = true;
          random_port = false;
          daemon_port = 58846;
          # listen_ports = [53394 53394];
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
            # "natpmp" # https://github.com/SloCompTech/deluge-natpmp-plugin
          ];
        };
      };
      deluge.web = {
        enable = true;
        port = 8112;
        openFirewall = true;
      };
    };

    systemd = {
      tmpfiles.rules = [
        "d /scratch/torrents 0755 deluge media -"
        "d /data/torrents 0775 deluge media -"
      ];
      timers.natpmp = {
        enable = true;
        description = "Renew NAT-PMP port forwarding for Deluge";
        after = ["network.target" "deluged.service"];
        wantedBy = ["timers.target"];

        timerConfig = {
          OnBootSec = "45s";
          OnUnitActiveSec = "45s";
          AccuracySec = "1s";
          RandomizedDelaySec = 0;
          FixedRandomDelay = false;
        };
      };
      services = {
        deluged = {
          after = ["network-online.target" "blocky.service"];
          wants = ["network-online.target" "blocky.service"];
        };
        natpmp = {
          enable = true;
          description = "Map Deluge TCP/UDP via NAT-PMP";
          after = ["network-online.target" "deluged.service"];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writers.writeBash "natpmp-deluge-sync" {
              makeWrapperArgs = [
                "--prefix"
                "PATH"
                ":"
                "${lib.makeBinPath [pkgs.curl pkgs.libnatpmp]}"
              ];
            } (builtins.readFile ./natpmp-sync.sh);
          };
        };
      };
    };

    sops.secrets.deluge = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "deluge";
      restartUnits = ["deluged.service" "delugeweb.service"];
    };
  };
}
