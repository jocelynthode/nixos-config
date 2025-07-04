{
  config,
  lib,
  ...
}: {
  options.aspects.services.acme.enable = lib.mkEnableOption "acme";

  config = lib.mkIf config.aspects.services.acme.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/acme"
    ];

    networking.firewall.allowedTCPPorts = [80 443];
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "acme@thode.email";
        webroot = "/var/lib/acme/acme-challenge"; # port 80 already opened in media/nginx
        extraLegoRunFlags = ["--preferred-chain" "ISRG Root X1"];
        extraLegoRenewFlags = ["--preferred-chain" "ISRG Root X1"];
      };
    };
  };
}
