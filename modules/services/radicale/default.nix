{ config, lib, pkgs, ... }: {
  options.aspects.services.radicale.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.radicale.enable {
    environment.persistence."${config.aspects.persistPrefix}".directories = [
      "/var/lib/radicale/collections"
    ];

    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [ "0.0.0.0:5232" ];
          ssl = true;
          certificate = "${config.security.acme.certs."dav.tekila.ovh".directory}/fullchain.pem";
          key = "${config.security.acme.certs."dav.tekila.ovh".directory}/key.pem";
        };
        auth = {
          type = "htpasswd";
          htpasswd_filename = config.sops.secrets.radicale.path;
          htpasswd_encryption = "bcrypt";
        };
      };
    };

    sops.secrets.radicale = {
      sopsFile = ../../../secrets/${config.aspects.base.network.hostname}/secrets.yaml; 
      owner = "radicale";
      group = "radicale";
      restartUnits = [ "radicale.service" ];
    };

    security.acme.certs = {
      "dav.tekila.ovh" = {
        listenHTTP = ":80";
        reloadServices = [ "radicale" ];
        group = "radicale";
      };
    };
  };
}
