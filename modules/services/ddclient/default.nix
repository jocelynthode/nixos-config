{
  config,
  lib,
  ...
}: {
  options.aspects.services.ddclient.enable = lib.mkEnableOption "ddclient";

  config = lib.mkIf config.aspects.services.ddclient.enable {
    services.ddclient = {
      enable = true;
      server = "www.ovh.com";
      ssl = true;
      username = "tekila.ovh-ident";
      domains = ["dyn.tekila.ovh"];
      passwordFile = config.sops.secrets.ddclient.path;
    };

    sops.secrets.ddclient = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      restartUnits = ["ddclient.service"];
    };
  };
}
