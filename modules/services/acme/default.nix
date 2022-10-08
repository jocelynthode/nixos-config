{ config, lib, pkgs, ... }: {
  options.aspects.services.acme.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.acme.enable {
    environment.persistence."${config.aspects.persistPrefix}".directories = [
      "/var/lib/acme"
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@thode.email";
      certs = {
        "dav.tekila.ovh" = {
          listenHTTP = ":80";
          reloadServices = [ "radicale" ];
          group = "radicale";
        };
      };
    };
  };
}
