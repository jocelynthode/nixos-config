{
  pkgs,
  config,
  lib,
  ...
}: {
  options.aspects.services.wireguard.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.wireguard.enable {
    networking.firewall = {
      allowedUDPPorts = [51820];
    };
    networking.wg-quick.interfaces = {
      wg0 = {
        address = ["10.2.0.2/32"];
        listenPort = 51820;
        table = "51820";
        dns = ["10.2.0.1"];
        privateKeyFile = config.sops.secrets.wireguard.path;
        preDown = [
          "${pkgs.iproute2}/bin/ip rule del from 10.2.0.2/32 table 51820"
          "${pkgs.iproute2}/bin/ip rule del to 10.2.0.1/32 table 51820"
        ];
        postUp = [
          "${pkgs.iproute2}/bin/ip rule add from 10.2.0.2/32 table 51820"
          "${pkgs.iproute2}/bin/ip rule add to 10.2.0.1/32 table 51820"
        ];
        peers = [
          {
            publicKey = "17I34jHOMcmI7LKBqxosTfLgwGjO5OKApLcRSPlyymM=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "185.159.157.13:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };

    sops.secrets.wireguard = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
    };
  };
}
