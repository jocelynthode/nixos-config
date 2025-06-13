{
  config,
  lib,
  ...
}: {
  options.aspects.services.wireguard.enable = lib.mkEnableOption "wireguard";

  config = lib.mkIf config.aspects.services.wireguard.enable {
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    # networking.wg-quick.interfaces = {
    #   wg0 = {
    #     address = ["10.2.0.2/32"];
    #     listenPort = 51820;
    #     table = "51820";
    #     dns = ["10.2.0.1"];
    #     privateKeyFile = config.sops.secrets.wireguard.path;
    #     preDown = [
    #       "${pkgs.iproute2}/bin/ip rule del from 10.2.0.2/32 table 51820"
    #       "${pkgs.iproute2}/bin/ip rule del to 10.2.0.1/32 table 51820"
    #     ];
    #     postUp = [
    #       "${pkgs.iproute2}/bin/ip rule add from 10.2.0.2/32 table 51820"
    #       "${pkgs.iproute2}/bin/ip rule add to 10.2.0.1/32 table 51820"
    #     ];
    #     peers = [
    #       {
    #         publicKey = "17I34jHOMcmI7LKBqxosTfLgwGjO5OKApLcRSPlyymM=";
    #         allowedIPs = ["0.0.0.0/0"];
    #         endpoint = "185.159.157.13:51820";
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };

    networking = {
      nat = {
        enable = true;
        externalInterface = "enp0s25";
        internalInterfaces = ["wg0"];
      };

      firewall = {
        allowedUDPPorts = [51820];
      };

      wireguard = {
        enable = true;
        interfaces = {
          wg0 = {
            ips = ["10.100.0.1/24"];
            listenPort = 51820;
            # publicekey: SpDNvpxroin151zzOzVhtJBUOfU9X5HnbtypZvJqJCo=
            privateKeyFile = config.sops.secrets."wireguard/privateServerKey".path;
            peers = [
              {
                # Phone
                publicKey = "Tn3W3R6ShdFPgsAGCDU6CQY2/kimfXS8jAItnNjZ7kU=";
                allowedIPs = ["10.100.0.2/32"];
              }
            ];
          };
        };
      };
    };

    sops.secrets = {
      "wireguard/privateServerKey" = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      };
    };
  };
}
