{ config, lib, ... }: {
  options.aspects.services.deluge.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.deluge.enable {
    networking.firewall = {
      allowedTCPPorts = [ 58846 ];
    };

    services = {
      deluge = {
        enable = true;
        dataDir = "/var/www/dde/deluge";
        declarative = true;
        openFirewall = true;
        authFile = config.sops.secrets.deluge.path;
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
      restartUnits = [ "deluged.service" "delugeweb.service" ];
    };
  };
}
