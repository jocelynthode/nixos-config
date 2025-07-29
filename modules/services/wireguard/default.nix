{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.aspects.services.wireguard.enable = lib.mkEnableOption "wireguard";

  config = lib.mkIf config.aspects.services.wireguard.enable {
    networking = {
      nat = {
        enable = true;
        externalInterface = "enp2s0";
        internalInterfaces = [ "wg0" ];
      };

      firewall = {
        allowedUDPPorts = [
          51820
        ];
      };

      wireguard = {
        enable = true;
        interfaces = {
          wg0 = {
            ips = [ "10.100.0.1/24" ];
            listenPort = 51820;

            # Setup if VPN is to be used to access Internet
            # postSetup = ''
            #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${config.networking.nat.externalInterface} -j MASQUERADE
            # '';
            # postShutdown = ''
            #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${config.networking.nat.externalInterface} -j MASQUERADE
            # '';

            # publicKey: Eq2xPRHp2sLRDaHR2ARHiMCR5oDWGxHeOrVlxI8LORo=
            privateKeyFile = config.sops.secrets."wireguard/privateServerKey".path;
            peers = [
              {
                # Phone
                publicKey = "SpDNvpxroin151zzOzVhtJBUOfU9X5HnbtypZvJqJCo=";
                allowedIPs = [ "10.100.0.2/32" ];
              }
              {
                # Steamdeck
                publicKey = "AET47zgzMVwu0Zkj7XoHeCAm7N1q+hLRmfa02yzd13c=";
                allowedIPs = [ "10.100.0.3/32" ];
              }
            ];
          };
          wg1 = {
            ips = [ "10.2.0.2/32" ];
            table = "51821";
            privateKeyFile = config.sops.secrets."wireguard/privateProtonKey".path;
            preShutdown = [
              "${pkgs.iproute2}/bin/ip rule del from 10.2.0.2/32 table 51821"
              "${pkgs.iproute2}/bin/ip rule del to 10.2.0.1/32 table 51821"
            ];
            postSetup = [
              "${pkgs.iproute2}/bin/ip rule add from 10.2.0.2/32 table 51821"
              "${pkgs.iproute2}/bin/ip rule add to 10.2.0.1/32 table 51821"
            ];
            peers = [
              {
                publicKey = "2k23lMcRa7U2sT5mlXQ/vVCIt1ltESheiVZMBAahLSQ=";
                allowedIPs = [ "0.0.0.0/0" ];
                endpoint = "79.127.184.129:51820";
                persistentKeepalive = 25;
              }
            ];
          };
        };
      };
    };

    # OpenFirewall for vpn port-mapping
    networking.firewall.trustedInterfaces = [ "wg1" ];

    sops.secrets = {
      "wireguard/privateServerKey" = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      };
      "wireguard/privateProtonKey" = {
        sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      };
    };
  };
}
