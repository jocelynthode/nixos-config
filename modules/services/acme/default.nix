{
  config,
  lib,
  ...
}: {
  options.aspects.services.acme.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.acme.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/acme"
    ];

    networking.firewall.allowedTCPPorts = [80 443];
    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@thode.email";
      defaults.webroot = "/var/lib/acme/acme-challenge"; # port 80 already opened in media/nginx
    };
  };
}
