{ config, lig, ... }: {
  options.aspects.services.wireguard.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.wireguard.enable {
    networking.firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    networking.wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ "10.2.0.2/24" ];
          listenPort = 51820;
          privateKeyFile = config.sops.secrets.wireguard.path;
          peers = [
            {
              publicKey = "VNNO5MYorFu1UerHvoXccW6TvotxbJ1GAGJKtzM9HTY=";
              allowedIPs = [ "0.0.0.0/0" ];
              endpoint = "185.159.157.23:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };

    sops.secrets.wireguard = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
    };
  };
}
