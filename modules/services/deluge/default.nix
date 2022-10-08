{ config, lib, pkgs, ... }: {
  options.aspects.services.deluge.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.deluge.enable {
    environment.etc = {
      "deluge/auth" = {
        text = ''
          deluge:deluge:5
        '';
        mode = "0440";
      };
    };

    services = {
      deluge = {
        enable = true;
        dataDir = "/var/www/dde/deluge";
      };
      deluge.web = {
        enable = true;
        port = 8112;
        openFirewall = true;
      };
    };
  };
}
