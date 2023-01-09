{
  config,
  lib,
  ...
}: {
  options.aspects.services.radicale.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.radicale.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/radicale/collections"
    ];

    networking.firewall.allowedTCPPorts = [5232];
    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = ["0.0.0.0:5232"];
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
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "radicale";
      group = "radicale";
      restartUnits = ["radicale.service"];
    };

    security.acme.certs = {
      "dav.tekila.ovh" = {
        reloadServices = ["radicale.service"];
        group = "radicale";
      };
    };
  };
}
