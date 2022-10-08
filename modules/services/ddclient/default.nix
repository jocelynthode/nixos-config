{ config, lib, pkgs, ... }: {
  options.aspects.services.ddclient.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.ddclient.enable {
    services.ddclient = {
      enable = true;
      server = "www.ovh.com";
      ssl = true;
      username = "tekila.ovh-ident";
      domains = [ "dyn.tekila.ovh" ];
      passwordFile = config.sops.secrets.ddclient.path;
    };

    sops.secrets.ddclient = {
      sopsFile = ../../../secrets/${config.aspects.base.network.hostname}/secrets.yaml;
      restartUnits = [ "ddclient.service" ];
    };
  };
}

